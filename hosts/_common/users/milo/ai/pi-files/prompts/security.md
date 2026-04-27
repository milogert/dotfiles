---
description: Security review
argument-hint: "[scope]"
---
Perform a security review.

Scope:
$ARGUMENTS

Focus on:
- secrets exposure
- unsafe shell/process execution
- auth/session flaws
- injection risks
- dependency risks
- Terraform/IaC risks if present
- file permission issues

Do not make changes initially. Report findings and recommended fixes.
