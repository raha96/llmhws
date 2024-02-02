# LLM Hardware Security Benchmarking Dataset

*Pre-Alpha Version*

This repository is meant to host a dataset of potential hardware vulnerabilites that includes "enough information to enable benchmarking of large language models." The exact meaning of this phrase is up for discussion. This is what we know or have decided on so far: 
 - The source data is maintained in YAML. It's human-readable and machine-parsable, and it can be conveniently version controlled via Git.
 - The resources to be used include (but are not limited to) Trust Hub, CAD4Assurance, CWE.
 - A complete record will include an English description of the vulnerability, CWE classification, SystemVerilog assertions, and the original source code for which the assertions have been written or a link to it, and licensing information.
 - Open source data is preferred to simplify sharing and contribution. If relevant high-quality data of a non-open nature becomes available, we will decide on how to deal with it.

# TODO

## Conceptual
 - Come up with a proper schema for sharing the data
 - Draft a contribution guide to inform uniformity
 - Decide on best practices in case of missing datapoints - how to avoid holes? How zealous should we be?
 - Decide on licensing and attribution

## Technical
 - Add GitHub actions to auto-generate the artifacts in other useful formats (probably JSON and SQLDB would suffice for now)

# Who are we?
Placeholder - the exact roles of the contributers are TBD
