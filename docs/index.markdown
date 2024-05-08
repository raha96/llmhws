---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

## Summary
{:style="text-align:center;"}

![Syntax Check Pass Rate for ChatGPT 3.5](./assets/syntax-pass-chatgpt.png)
{:style="text-align:center;"}

![Assertion Success Rate for ChatGPT 3.5](./assets/assertion-pass-chatgpt.png)
{:style="text-align:center;"}

![Syntax Check Pass Rate for Codellama](./assets/syntax-pass-codellama.png)
{:style="text-align:center;"}

![Assertion Success Rate for Codellama](./assets/assertion-pass-codellama.png)
{:style="text-align:center;"}

## State of Benchmarking - ChatGPT 3.5
{:style="text-align:center;"}

| Design | Test # | Verbosity | # Lines | First Attempt - Syntax | First Attempt - Assertion | Five Attempts - Syntax | Five Attempts - Assertion |
| ------ | ------ | --------- | ------- | ---------------------- | ------------------------- | ---------------------- | ------------------------- |
| REM021 | 1 | Low | 2 | ✓ | ✓ | 80% | 80% |
| REM021 | 2 | Low | 24 | ✓ | ✗ | 100% | 40% |
| REM021 | 3 | Low | 25 | ✓ | ✓ | 100% | 100% |
| REM021 | 4 | Medium | 2 | ✓ | ✓ | 100% | 80% |
| REM021 | 5 | Medium | 24 | ✓ | ✓ | 100% | 100% |
| REM021 | 6 | Medium | 25 | ✓ | ✓ | 100% | 100% |
| REM021 | 7 | High | 2 | ✓ | ✗ | 100% | 40% |
| REM021 | 8 | High | 24 | ✓ | ✓ | 100% | 100% |
| REM021 | 9 | High | 25 | ✓ | ✓ | 80% | 80% |
| REM031 | 1 | Low | 1 | ✓ | ✓ | 100% | 80% |
| REM031 | 2 | Low | 3 | ✓ | ✗ | 80% | 0% |
| REM031 | 3 | Low | 5 | ✗ | ✗ | 60% | 0% |
| REM031 | 4 | Low | 7 | ✓ | ✗ | 40% | 0% |
| REM031 | 5 | Medium | 1 | ✗ | ✗ | 60% | 20% |
| REM031 | 6 | Medium | 3 | ✓ | ✗ | 60% | 0% |
| REM031 | 7 | Medium | 5 | ✗ | ✗ | 40% | 0% |
| REM031 | 8 | Medium | 7 | ✓ | ✗ | 80% | 0% |
| REM031 | 9 | High | 1 | ✓ | ✓ | 100% | 100% |
| REM031 | 10 | High | 3 | ✗ | ✗ | 40% | 0% |
| REM031 | 11 | High | 5 | ✓ | ✗ | 40% | 0% |
| REM031 | 12 | High | 7 | ✓ | ✗ | 80% | 20% |
| REM041 | 1 | Low | 1 | ✓ | ✓ | 100% | 100% |
| REM041 | 2 | Low | 2 | ✓ | ✓ | 100% | 100% |
| REM041 | 3 | Low | 3 | ✓ | ✗ | 100% | 0% |
| REM041 | 4 | Medium | 1 | ✓ | ✓ | 100% | 100% |
| REM041 | 5 | Medium | 2 | ✓ | ✓ | 80% | 80% |
| REM041 | 6 | Medium | 3 | ✓ | ✗ | 60% | 0% |
| REM041 | 7 | High | 1 | ✓ | ✓ | 100% | 100% |
| REM041 | 8 | High | 2 | ✓ | ✓ | 100% | 100% |
| REM041 | 9 | High | 3 | ✓ | ✗ | 100% | 0% |
| REM042 | 1 | Low | 3 | ✓ | ✗ | 100% | 60% |
| REM042 | 2 | Low | 8 | ✓ | ✓ | 100% | 100% |
| REM042 | 3 | Low | 10 | ✓ | ✓ | 80% | 20% |
| REM042 | 4 | Medium | 3 | ✓ | ✓ | 100% | 80% |
| REM042 | 5 | Medium | 8 | ✓ | ✓ | 100% | 60% |
| REM042 | 6 | Medium | 10 | ✓ | ✗ | 100% | 40% |
| REM042 | 7 | High | 3 | ✓ | ✗ | 100% | 80% |
| REM042 | 8 | High | 8 | ✓ | ✓ | 100% | 100% |
| REM042 | 9 | High | 10 | ✓ | ✓ | 100% | 100% |
| REM043 | 1 | Low | 2 | ✓ | ✓ | 100% | 20% |
| REM043 | 2 | Low | 8 | ✓ | ✗ | 100% | 0% |
| REM043 | 3 | Low | 10 | ✓ | ✗ | 80% | 0% |
| REM043 | 4 | Medium | 2 | ✓ | ✓ | 100% | 40% |
| REM043 | 5 | Medium | 8 | ✓ | ✗ | 100% | 60% |
| REM043 | 6 | Medium | 10 | ✓ | ✗ | 80% | 0% |
| REM043 | 7 | High | 2 | ✓ | ✗ | 100% | 0% |
| REM043 | 8 | High | 8 | ✓ | ✗ | 100% | 0% |
| REM043 | 9 | High | 10 | ✓ | ✗ | 60% | 0% |
| REM051 | 1 | Low | 1 | ✓ | ✓ | 100% | 20% |
| REM051 | 2 | Low | 1 | ✓ | No Cover | 100% | 0% |
| REM051 | 3 | Low | 7 | ✓ | No Cover | 100% | 20% |
| REM051 | 4 | Medium | 1 | ✓ | ✗ | 100% | 60% |
| REM051 | 5 | Medium | 1 | ✓ | ✓ | 100% | 20% |
| REM051 | 6 | Medium | 7 | ✓ | ✓ | 100% | 20% |
| REM051 | 7 | High | 1 | ✓ | ✓ | 100% | 20% |
| REM051 | 8 | High | 1 | ✓ | ✓ | 100% | 60% |
| REM051 | 9 | High | 7 | ✓ | ✗ | 100% | 0% |
| RMI041 | 1 | Low | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 2 | Low | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 3 | Low | 2 | ✓ | ✓ | 100% | 100% |
| RMI041 | 4 | Low | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 5 | Low | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 6 | Low | 15 | ✓ | ✓ | 80% | 80% |
| RMI041 | 7 | Medium | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 8 | Medium | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 9 | Medium | 2 | ✓ | ✓ | 100% | 100% |
| RMI041 | 10 | Medium | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 11 | Medium | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 12 | Medium | 15 | ✓ | ✓ | 100% | 100% |
| RMI041 | 13 | High | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 14 | High | 1 | ✓ | ✓ | 100% | 100% |
| RMI041 | 15 | High | 2 | ✓ | ✓ | 100% | 100% |
| RMI041 | 16 | High | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 17 | High | 5 | ✓ | ✓ | 100% | 100% |
| RMI041 | 18 | High | 15 | ✓ | ✓ | 100% | 100% |


## State of Benchmarking - Codellama
{:style="text-align:center;"}

| Design | Test # | Verbosity | # Lines | First Attempt - Syntax | First Attempt - Assertion | Five Attempts - Syntax | Five Attempts - Assertion |
| ------ | ------ | --------- | ------- | ---------------------- | ------------------------- | ---------------------- | ------------------------- |
| REM021 | 1 | Low | 2 | No Code | ✗ | 0% | 0% |
| REM021 | 2 | Low | 24 | No Code | ✗ | 0% | 0% |
| REM021 | 3 | Low | 25 | No Code | ✗ | 0% | 0% |
| REM021 | 4 | Medium | 2 | No Code | ✗ | 0% | 0% |
| REM021 | 5 | Medium | 24 | No Code | ✗ | 0% | 0% |
| REM021 | 6 | Medium | 25 | No Code | ✗ | 0% | 0% |
| REM021 | 7 | High | 2 | No Code | ✗ | 0% | 0% |
| REM021 | 8 | High | 24 | ✗ | ✗ | 0% | 0% |
| REM021 | 9 | High | 25 | No Code | ✗ | 0% | 0% |
| REM031 | 1 | Low | 1 | ✗ | ✗ | 0% | 0% |
| REM031 | 2 | Low | 3 | ✗ | ✗ | 0% | 0% |
| REM031 | 3 | Low | 5 | ✗ | ✗ | 0% | 0% |
| REM031 | 4 | Low | 7 | ✗ | ✗ | 0% | 0% |
| REM031 | 5 | Medium | 1 | ✗ | ✗ | 0% | 0% |
| REM031 | 6 | Medium | 3 | ✗ | ✗ | 0% | 0% |
| REM031 | 7 | Medium | 5 | ✗ | ✗ | 0% | 0% |
| REM031 | 8 | Medium | 7 | ✗ | ✗ | 0% | 0% |
| REM031 | 9 | High | 1 | ✗ | ✗ | 0% | 0% |
| REM031 | 10 | High | 3 | ✗ | ✗ | 0% | 0% |
| REM031 | 11 | High | 5 | ✗ | ✗ | 0% | 0% |
| REM031 | 12 | High | 7 | ✗ | ✗ | 0% | 0% |
| REM041 | 1 | Low | 1 | No Code | ✗ | 0% | 0% |
| REM041 | 2 | Low | 2 | ✗ | ✗ | 0% | 0% |
| REM041 | 3 | Low | 3 | No Code | ✗ | 0% | 0% |
| REM041 | 4 | Medium | 1 | No Code | ✗ | 0% | 0% |
| REM041 | 5 | Medium | 2 | ✗ | ✗ | 0% | 0% |
| REM041 | 6 | Medium | 3 | ✗ | ✗ | 0% | 0% |
| REM041 | 7 | High | 1 | No Code | ✗ | 0% | 0% |
| REM041 | 8 | High | 2 | ✗ | ✗ | 0% | 0% |
| REM041 | 9 | High | 3 | ✗ | ✗ | 0% | 0% |
| REM042 | 1 | Low | 3 | ✗ | ✗ | 0% | 0% |
| REM042 | 2 | Low | 8 | ✗ | ✗ | 0% | 0% |
| REM042 | 3 | Low | 10 | ✗ | ✗ | 0% | 0% |
| REM042 | 4 | Medium | 3 | ✗ | ✗ | 0% | 0% |
| REM042 | 5 | Medium | 8 | ✗ | ✗ | 0% | 0% |
| REM042 | 6 | Medium | 10 | ✗ | ✗ | 0% | 0% |
| REM042 | 7 | High | 3 | ✗ | ✗ | 0% | 0% |
| REM042 | 8 | High | 8 | ✗ | ✗ | 0% | 0% |
| REM042 | 9 | High | 10 | ✗ | ✗ | 0% | 0% |
| REM043 | 1 | Low | 2 | ✗ | ✗ | 0% | 0% |
| REM043 | 2 | Low | 8 | ✗ | ✗ | 0% | 0% |
| REM043 | 3 | Low | 10 | ✗ | ✗ | 0% | 0% |
| REM043 | 4 | Medium | 2 | ✗ | ✗ | 0% | 0% |
| REM043 | 5 | Medium | 8 | ✗ | ✗ | 0% | 0% |
| REM043 | 6 | Medium | 10 | No Code | ✗ | 0% | 0% |
| REM043 | 7 | High | 2 | No Code | ✗ | 0% | 0% |
| REM043 | 8 | High | 8 | ✗ | ✗ | 0% | 0% |
| REM043 | 9 | High | 10 | ✗ | ✗ | 0% | 0% |
| REM051 | 1 | Low | 1 | No Code | ✗ | 0% | 0% |
| REM051 | 2 | Low | 1 | No Code | ✗ | 0% | 0% |
| REM051 | 3 | Low | 7 | No Code | ✗ | 0% | 0% |
| REM051 | 4 | Medium | 1 | ✗ | ✗ | 0% | 0% |
| REM051 | 5 | Medium | 1 | No Code | ✗ | 0% | 0% |
| REM051 | 6 | Medium | 7 | No Code | ✗ | 0% | 0% |
| REM051 | 7 | High | 1 | No Code | ✗ | 0% | 0% |
| REM051 | 8 | High | 1 | No Code | ✗ | 0% | 0% |
| REM051 | 9 | High | 7 | No Code | ✗ | 0% | 0% |
| RMI041 | 1 | Low | 1 | No Code | ✗ | 60% | 60% |
| RMI041 | 2 | Low | 1 | ✓ | ✓ | 80% | 80% |
| RMI041 | 3 | Low | 2 | No Code | ✗ | 20% | 20% |
| RMI041 | 4 | Low | 5 | ✓ | ✓ | 80% | 80% |
| RMI041 | 5 | Low | 5 | No Code | ✗ | 40% | 40% |
| RMI041 | 6 | Low | 15 | ✓ | ✓ | 100% | 100% |
| RMI041 | 7 | Medium | 1 | No Code | ✗ | 20% | 20% |
| RMI041 | 8 | Medium | 1 | No Code | ✗ | 60% | 60% |
| RMI041 | 9 | Medium | 2 | ✓ | ✓ | 80% | 80% |
| RMI041 | 10 | Medium | 5 | ✓ | ✓ | 80% | 80% |
| RMI041 | 11 | Medium | 5 | No Code | ✗ | 40% | 40% |
| RMI041 | 12 | Medium | 15 | ✓ | ✓ | 100% | 100% |
| RMI041 | 13 | High | 1 | ✓ | ✓ | 60% | 60% |
| RMI041 | 14 | High | 1 | No Code | ✗ | 40% | 40% |
| RMI041 | 15 | High | 2 | ✓ | ✓ | 60% | 60% |
| RMI041 | 16 | High | 5 | ✓ | ✓ | 60% | 60% |
| RMI041 | 17 | High | 5 | No Code | ✗ | 0% | 0% |
| RMI041 | 18 | High | 15 | ✗ | ✗ | 60% | 60% |
