---
name: terraform-safety
description: Work safely with Terraform. Use for Terraform formatting, validation, planning, module review, and infrastructure change analysis. Confirm before apply or destroy.
---

# Terraform Safety

## Rules

- `terraform fmt`, `terraform validate`, and `terraform plan` are acceptable verification commands.
- Always ask before `terraform apply`, `terraform destroy`, or commands that mutate remote infrastructure.
- Inspect provider/backend configuration before proposing changes.
- Watch for public exposure, overly broad IAM, missing encryption, unsafe lifecycle rules, and state handling.
- Prefer small, reviewable infrastructure changes.

## Output

For changes, summarize:
- resources affected
- possible blast radius
- verification performed
- commands the user must run manually, if any
