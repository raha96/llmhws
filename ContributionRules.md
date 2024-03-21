These rules are meant to ensure uniformity. They also serve as valid assumptions on part of any automated scripts processing the data. If there's an actual need to change one of these rules, open an issue and ensure that all existing data is properly updated to reflect the change. 

The ground rules: 
https://learnxinyminutes.com/docs/yaml/

Style rules: 
1. Use 2 whitespaces for indentation. 
2. Only represent null as `null`. 
3. Only represent Boolean values as `true` or `false`. 
4. Always quote strings, except multiline strings and keys. 
5. Never quote multiline strings and keys. 
6. Double quotes are preferred unless you need to use nested quotes.
7. Avoid escape characters if possible, e.g. by using single quotes inside double quotes.
8. Avoid quoting anything except strings.
9. Only use ASCII characters. 

Valid "Severity" values: "Strategy", "Decision", "Typo"
