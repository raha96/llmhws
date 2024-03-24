from sys import argv
import re

promptline = re.compile(r"-- Instructions for .+: ")

if __name__ == "__main__":
    if len(argv) != 4:
        print("Usage: python " + argv[0] + " <prompt> <llm-generated-code> <output-path>")
        exit(1)
    
    promptpath = argv[1]
    llmcodepath = argv[2]
    outpath = argv[3]

    with open(llmcodepath, "r") as fin:
        gencode = fin.readlines()
    
    fout = open(outpath, "w")
    fin = open(promptpath, "r")

    replaced = False
    for line in fin:
        if line.strip() == gencode[0].strip():
            # Match, insert the generated code here
            replaced = True
            for _line in gencode:
                fout.write(_line)
        elif replaced:
            if line.strip() == gencode[-1].strip():
                # Reject lines till the replaced part is completely over
                replaced = False
        else:
            fout.write(line)

    fout.close()
    fin.close()
