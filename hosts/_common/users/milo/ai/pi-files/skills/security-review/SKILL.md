---
name: security-review
description: Review code or infrastructure for security issues including secrets, injection, unsafe shell execution, auth/session flaws, dependency risks, and Terraform/IaC mistakes.
---

# Security Review

Perform security review before making fixes unless explicitly asked to patch immediately.

## Checklist

- Secrets and credentials committed or logged
- Unsafe shell/process execution
- Injection risks: SQL, shell, template, path traversal, SSRF
- Authentication and authorization gaps
- Session/cookie/token handling
- Insecure defaults and missing validation
- Dependency and supply-chain risks
- Terraform/IaC risks: public exposure, permissive IAM, unencrypted storage, destructive changes
- File permissions and local secret handling

## Output

Prioritize findings by severity. For each finding include:
- severity
- affected file/location
- why it matters
- minimal recommended fix
