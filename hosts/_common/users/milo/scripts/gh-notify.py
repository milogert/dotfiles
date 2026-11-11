import json, os, subprocess, sys

wanted = set(os.environ["REASONS"].split(","))
show_body = os.environ["SHOW_BODY"] != "0"
maxlines = int(os.environ["MAXLINES"])
organizations = os.environ["ORGANIZATIONS"].split(",")

BOLD, GREEN, BLUE, DIM, OFF = "\033[1m", "\033[1;32m", "\033[4;34m", "\033[2m", "\033[0m"

# --paginate concatenates JSON arrays; read them as a stream.
notes, dec = [], json.JSONDecoder()
buf = sys.stdin.read().lstrip()
while buf:
    page, idx = dec.raw_decode(buf)
    notes.extend(page)
    buf = buf[idx:].lstrip()

def comment(note):
    """Body of the triggering comment, or None if there is not a distinct one."""
    url = note["subject"].get("latest_comment_url") or ""
    # When no one has commented, GitHub points this at the issue/PR itself --
    # that body is the PR description, not a comment, so skip it.
    if "/comments/" not in url:
        return None
    out = subprocess.run(["gh", "api", url], capture_output=True, text=True)
    if out.returncode != 0:
        return None
    d = json.loads(out.stdout)
    return d.get("user", {}).get("login"), (d.get("body") or "").strip()

shown = 0
for n in notes:
    # Filter reasons
    reason = n.get("reason", "")
    if "all" not in wanted and reason not in wanted:
        continue

    # Filter organizations
    organization = n["repository"]["owner"]["login"]
    if organizations != "" and organization not in organizations:
        continue

    shown += 1
    subj, repo = n["subject"], n["repository"]["full_name"]

    # The API returns api.github.com URLs; rewrite to the clickable web one.
    web = (subj.get("url") or "").replace("api.github.com/repos", "github.com") \
                                .replace("/pulls/", "/pull/")

    title = subj.get("title", "")
    print(f"\n{GREEN}*{OFF} {BOLD}{title}{OFF}")
    print(f"  {DIM}{repo} - {reason}{OFF}")

    if show_body:
        c = comment(n)
        if c:
            who, body = c
            lines = [l for l in body.replace("\r", "").splitlines()]
            for l in lines[:maxlines]:
                print(f"  {l}")
            if len(lines) > maxlines:
                print(f"  {DIM}... +{len(lines) - maxlines} more lines{OFF}")
            print(f"  {DIM}-- {who}{OFF}")

    if web:
        print(f"  {BLUE}{web}{OFF}")

if not shown:
    print("nothing new")
