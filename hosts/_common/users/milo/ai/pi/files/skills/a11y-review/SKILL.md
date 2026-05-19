---
name: a11y-review
description: Review frontend code for accessibility issues including semantic HTML, keyboard navigation, focus management, labels, ARIA, contrast, and reduced motion.
---

# Accessibility Review

Review before patching unless asked to fix immediately.

## Checklist

- Semantic HTML and landmark structure
- Keyboard access and visible focus states
- Correct form labels and error messaging
- ARIA necessity and correctness; avoid ARIA when semantic HTML is better
- Color contrast and non-color indicators
- Screen reader names/descriptions
- Motion and reduced-motion support
- Dialogs, menus, popovers, and focus traps

## Output

Prioritize issues by user impact. Suggest minimal, idiomatic fixes.
