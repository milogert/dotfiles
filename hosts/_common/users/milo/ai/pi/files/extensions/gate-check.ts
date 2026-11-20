import path from 'node:path'
import type {
  ExtensionAPI,
  ExtensionContext,
} from '@earendil-works/pi-coding-agent'

const secretPathPatterns = [
  /(^|[/\\])\.env(\..*)?$/i,
  /(^|[/\\])\.ssh([/\\]|$)/i,
  /(^|[/\\])\.gnupg([/\\]|$)/i,
  /(^|[/\\])id_(rsa|ed25519|ecdsa)(\.pub)?$/i,
  /(^|[/\\])(secrets?|credentials?|tokens?|passwords?)([/\\.]|$)/i,
  /(^|[/\\])(.*secret.*|.*credential.*|.*token.*|.*password.*)$/i,
]

type RiskyPattern = Array<{ pattern: RegExp; reason: string }>

const riskyCommandPatterns: RiskyPattern = [
  { pattern: /\bsudo\b/i, reason: 'uses sudo' },
  {
    pattern: /\brm\s+(?:-[^\n]*r|--recursive)\b/i,
    reason: 'recursively removes files',
  },
  { pattern: /\brm\s+(?:-[^\n]*f|--force)\b/i, reason: 'force-removes files' },
  { pattern: /\b(git\s+push|git\s+push\b)/i, reason: 'pushes git history' },
  { pattern: /\bgit\s+commit\b/i, reason: 'creates a git commit' },
  {
    pattern: /\bterraform\s+(apply|destroy)\b/i,
    reason: 'mutates infrastructure',
  },
  { pattern: /\btofu\s+(apply|destroy)\b/i, reason: 'mutates infrastructure' },
  {
    pattern: /\b(kubectl|helm)\s+.*\b(apply|delete|upgrade|rollback)\b/i,
    reason: 'mutates cluster state',
  },
  {
    pattern:
      /\b(npm|pnpm|yarn|bun|pip|pipx|cargo|go)\s+.*\b(install|add|remove|update|upgrade)\b/i,
    reason: 'changes dependencies or installed tools',
  },
  {
    pattern: /\b(nix\s+profile|nix-env)\b/i,
    reason: 'changes user/global Nix profile',
  },
  { pattern: /\b(chmod|chown)\b/i, reason: 'changes permissions/ownership' },
  {
    pattern: /\bdeploy\b|\brelease\b/i,
    reason: 'looks like a deploy/release command',
  },
  {
    pattern: /\bmix\s+ecto\.(migrate|rollback|reset|drop|create)\b/i,
    reason: 'changes database state',
  },
]

function normalizeCandidate(
  cwd: string,
  candidate: unknown,
): string | undefined {
  if (typeof candidate !== 'string' || candidate.length === 0) return undefined
  const stripped = candidate.startsWith('@') ? candidate.slice(1) : candidate
  return path.resolve(cwd, stripped)
}

function isInside(
  allowedDirectories: string[],
  parent: string,
  child: string,
): boolean {
  return [parent, ...allowedDirectories].some((directory) => {
    const relative = path.relative(directory, child)
    return (
      relative === '' ||
      (relative !== '..' &&
        !relative.startsWith(`..${path.sep}`) &&
        !path.isAbsolute(relative))
    )
  })
}

function pathLooksSecret(filePath: string): boolean {
  return secretPathPatterns.some((pattern) => pattern.test(filePath))
}

enum FeaturesEnum {
  editOutsideDirectory = 'edit-outside-directory',
  editSecretFile = 'edit-secret-file',
  riskyCommand = 'risky-command',
  status = 'status',
}

type FeaturesType = {
  [FeaturesEnum.editOutsideDirectory]: string[]
  [FeaturesEnum.editSecretFile]: boolean
  [FeaturesEnum.riskyCommand]: boolean
}

export default function (pi: ExtensionAPI) {
  const features: FeaturesType = {
    [FeaturesEnum.editOutsideDirectory]: [],
    [FeaturesEnum.editSecretFile]: true,
    [FeaturesEnum.riskyCommand]: true,
  }

  const sessionApprovals = new Set<string>()
  const sessionDirectories = new Set<string>()

  pi.on('session_start', () => {
    sessionApprovals.clear()
    sessionDirectories.clear()
  })

  async function confirmOrBlock(
    ctx: ExtensionContext,
    title: string,
    body: string,
    scope: string,
    approvals = sessionApprovals,
  ) {
    if (approvals.has(scope)) return undefined
    if (!ctx.hasUI) {
      return {
        block: true,
        reason: `${title} blocked: no interactive UI for confirmation`,
      }
    }

    const choice = await ctx.ui.select(
      `${title}\n\n${body}\n\nSession approval: ${scope}`,
      ['Confirm', 'Block', 'Confirm for session'],
    )
    if (choice === 'Confirm for session') approvals.add(scope)
    if (choice === 'Confirm' || choice === 'Confirm for session')
      return undefined
    return { block: true, reason: `${title} blocked by user` }
  }

  pi.on('tool_call', async (event, ctx) => {
    if (event.toolName === 'bash') {
      if (!features[FeaturesEnum.riskyCommand]) {
        return undefined
      }

      const command = String(
        (event.input as { command?: unknown }).command ?? '',
      )
      const match = riskyCommandPatterns.find(({ pattern }) =>
        pattern.test(command),
      )
      if (!match) {
        return undefined
      }

      return confirmOrBlock(
        ctx,
        'Risky command',
        `Reason: ${match.reason}\n\nCommand:\n${command}\n\nAllow this command?`,
        `command: ${command}`,
      )
    }

    if (event.toolName === 'write' || event.toolName === 'edit') {
      const target = normalizeCandidate(
        ctx.cwd,
        (event.input as { path?: unknown }).path,
      )
      if (!target) {
        return undefined
      }

      if (
        !isInside(
          [
            ...features[FeaturesEnum.editOutsideDirectory],
            ...sessionDirectories,
          ],
          ctx.cwd,
          target,
        )
      ) {
        const blocked = await confirmOrBlock(
          ctx,
          'Write outside working directory',
          `Tool: ${event.toolName}\nTarget: ${target}\nWorking directory: ${ctx.cwd}\n\nAllow this write?`,
          path.dirname(target),
          sessionDirectories,
        )
        if (blocked) return blocked
      }

      if (features[FeaturesEnum.editSecretFile] && pathLooksSecret(target)) {
        return confirmOrBlock(
          ctx,
          'Possible secret file write',
          `Tool: ${event.toolName}\nTarget: ${target}\n\nThis path looks like it may contain secrets or credentials. Allow this write?`,
          `secret file: ${target}`,
        )
      }
    }

    return undefined
  })

  pi.on('user_bash', async (event, ctx) => {
    if (!features[FeaturesEnum.riskyCommand]) {
      return undefined
    }

    const match = riskyCommandPatterns.find(({ pattern }) =>
      pattern.test(event.command),
    )

    if (!match) return undefined

    const blocked = await confirmOrBlock(
      ctx,
      'Risky shell command',
      `Reason: ${match.reason}\n\nCommand:\n${event.command}\n\nAllow this command?`,
      `command: ${event.command}`,
    )

    if (blocked) {
      return {
        result: {
          cancelled: false,
          exitCode: 1,
          output: blocked.reason,
          truncated: false,
        },
      }
    }

    return undefined
  })

  pi.registerCommand('gate-check', {
    description: `Manage the safety gate features:
Prompts offer Confirm, Block, or Confirm for session. Session approvals cover the displayed
directory, exact secret path, or exact command and are cleared on session start/reload.
/gate-check
  (edit-outside-directory|edit-secret-file|risky-command) [on|off|TOGGLE]
    Changes one of the settings. If you omit the second argument it toggles the setting.

  edit-outside-directory (add|remove|reset) directory1 directory2 ...
    Adds or removes the list of directories. If you call \`reset\` it removes all directories from the array.

  status
    Displays the status`,

    getArgumentCompletions: (prefix) => {
      const [command, subcommand] = prefix.trimStart().split(' ', 2)

      let matches: { value: string; label: string }[]

      if (subcommand === undefined) {
        matches = [
          FeaturesEnum.editOutsideDirectory,
          FeaturesEnum.editSecretFile,
          FeaturesEnum.riskyCommand,
        ]
          .filter((value) => value.startsWith(command.toLowerCase().trim()))
          .map((value) => ({ label: value, value: `${value} ` }))

        if (matches.length) {
          return matches
        }
      }

      matches = ['on', 'off', 'toggle']
        .filter((value) =>
          value.startsWith((subcommand || '').toLowerCase().trim()),
        )
        .map((value) => ({ label: value, value: `${command} ${value} ` }))

      if (matches.length) {
        return matches
      }

      return null
    },
    handler: async (args, ctx) => {
      const [command, subcommand, ...subcommandArgs] = args.trim().split(/\s+/)

      if (command === FeaturesEnum.status) {
        ctx.ui.notify(
          Object.entries(features)
            .map(([feature, value]) => {
              return `${feature} -> ${value}`
            })
            .join('\n'),
        )
        return
      }

      if (command === FeaturesEnum.editOutsideDirectory) {
        if (subcommand === 'add') {
          features[FeaturesEnum.editOutsideDirectory] = [
            ...new Set([
              ...features[FeaturesEnum.editOutsideDirectory],
              ...subcommandArgs.map((directory) =>
                path.resolve(ctx.cwd, directory),
              ),
            ]),
          ]
          ctx.ui.notify(
            `Added ${subcommandArgs} to editable directories`,
            'info',
          )
        } else if (subcommand === 'remove') {
          features[FeaturesEnum.editOutsideDirectory] = features[
            FeaturesEnum.editOutsideDirectory
          ].filter(
            (dir) =>
              !subcommandArgs.some(
                (directory) => path.resolve(ctx.cwd, directory) === dir,
              ),
          )
          for (const directory of subcommandArgs) {
            sessionDirectories.delete(path.resolve(ctx.cwd, directory))
          }
          ctx.ui.notify(
            `Removed ${subcommandArgs} to editable directories`,
            'info',
          )
        } else if (subcommand === 'reset') {
          features[FeaturesEnum.editOutsideDirectory] = []
          sessionDirectories.clear()
          ctx.ui.notify(`Reset editable directories`, 'info')
        } else {
          ctx.ui.notify(
            '/gate-check edit-outside-directory (add|remove) directory1 directory2 ...',
          )
        }
        return
      }

      if (
        command !== FeaturesEnum.editSecretFile &&
        command !== FeaturesEnum.riskyCommand
      ) {
        ctx.ui.notify(
          '/gate-check edit-outside-directory|edit-secret-file|risky-command on|off|toggle',
        )
        return
      }

      if (subcommand) {
        switch (subcommand) {
          case 'on':
            features[command] = true
            break

          case 'off':
            features[command] = false
            break

          case 'toggle':
            features[command] = !features[command]
            break

          default:
            ctx.ui.notify(`${subcommand} is not one of on|off|toggle`, 'info')
            return
        }
      } else {
        features[command] = !features[command]
      }

      ctx.ui.notify(`${command} set to ${features[command]}`, 'info')
    },
  })
}
