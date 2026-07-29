{ config, lib, ... }:

let
  piDir = "${config.home.homeDirectory}/.pi";
in
{
  home.file = {
    "${piDir}/agent/settings.json".text = lib.generators.toJSON { } {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.5";
      defaultThinkingLevel = "medium";
      theme = "srcery";
      hideThinkingBlock = false;
      enableInstallTelemetry = false;
      steeringMode = "one-at-a-time";
      followUpMode = "one-at-a-time";
      doubleEscapeAction = "tree";
      treeFilterMode = "no-tools";
      enableSkillCommands = true;

      compaction = {
        enabled = true;
        reserveTokens = 16384;
        keepRecentTokens = 24000;
      };

      branchSummary = {
        skipPrompt = false;
      };
    };

    "${piDir}/agent/themes/srcery.json".text = lib.generators.toJSON { } {
      "$schema" =
        "https://raw.githubusercontent.com/badlogic/pi-mono/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
      name = "srcery";
      vars = {
        bg = "#1c1b19";
        bgAlt = "#2d2b28";
        bgSoft = "#262522";
        fg = "#fce8c3";
        black = "#1c1b19";
        red = "#ef2f27";
        green = "#519f50";
        yellow = "#fbb829";
        blue = "#2c78bf";
        magenta = "#e02c6d";
        cyan = "#0aaeb3";
        white = "#baa67f";
        orange = "#ff5f00";
        gray = "#918175";
        darkGray = "#5f5a53";
      };
      colors = {
        accent = "orange";
        border = "gray";
        borderAccent = "orange";
        borderMuted = "darkGray";
        success = "green";
        error = "red";
        warning = "yellow";
        muted = "gray";
        dim = "darkGray";
        text = "";
        thinkingText = "gray";

        selectedBg = "bgAlt";
        userMessageBg = "bgSoft";
        userMessageText = "";
        customMessageBg = "bgSoft";
        customMessageText = "";
        customMessageLabel = "cyan";
        toolPendingBg = "bgSoft";
        toolSuccessBg = "#1f2a1f";
        toolErrorBg = "#321f1d";
        toolTitle = "orange";
        toolOutput = "";

        mdHeading = "yellow";
        mdLink = "cyan";
        mdLinkUrl = "gray";
        mdCode = "green";
        mdCodeBlock = "";
        mdCodeBlockBorder = "darkGray";
        mdQuote = "gray";
        mdQuoteBorder = "darkGray";
        mdHr = "darkGray";
        mdListBullet = "orange";

        toolDiffAdded = "green";
        toolDiffRemoved = "red";
        toolDiffContext = "gray";

        syntaxComment = "gray";
        syntaxKeyword = "orange";
        syntaxFunction = "yellow";
        syntaxVariable = "fg";
        syntaxString = "green";
        syntaxNumber = "magenta";
        syntaxType = "cyan";
        syntaxOperator = "orange";
        syntaxPunctuation = "gray";

        thinkingOff = "darkGray";
        thinkingMinimal = "gray";
        thinkingLow = "blue";
        thinkingMedium = "cyan";
        thinkingHigh = "yellow";
        thinkingXhigh = "red";
        bashMode = "yellow";
      };
      export = {
        pageBg = "#1c1b19";
        cardBg = "#262522";
        infoBg = "#2d2b28";
      };
    };

    "${piDir}/agent/AGENTS.md".source = ./pi-files/AGENTS.md;

    "${piDir}/agent/prompts" = {
      source = ./pi-files/prompts;
      recursive = true;
    };

    "${piDir}/agent/skills" = {
      source = ./pi-files/skills;
      recursive = true;
    };

    "${piDir}/agent/extensions" = {
      source = ./pi-files/extensions;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
