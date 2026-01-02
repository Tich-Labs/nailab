security: sanitize templates, fix ERB parse issues, add noopener to external links

Summary
- Fixes multiple template issues that caused template parse errors and XSS risk.
- Replaces unsafe html_safe outputs with sanitize(...) where appropriate.
- Adds rel="noopener noreferrer" to external links opened in new tabs.
- Simplifies ERB control-flow in templates to resolve parse errors.
- Includes updated static analysis reports (Brakeman, RuboCop, rails_best_practices).

See attached reports: brakeman_after3.txt, rubocop_after.txt, railsbp_report.txt

(Additional details were prepared in the branch.)
