from sys import argv
import yaml
import os.path
import re

is_annotation = re.compile(r"(--|//) *_LLMHWS_(.+)_(BEGIN|END)_")

class name_generator:
    def __init__(self, extension:str):
        extension = extension.lower()
        if extension == "vhd":
            self.language = "vhdl"
        elif extension == "v" or extension == "sv":
            self.language = "verilog"
        else:
            raise f"Unsupported file extension `{extension}`"
    def generate_name(self, base:str, isbegin:bool) -> str:
        out = ""
        if self.language == "vhdl":
            out = "-- "
        elif self.language == "verilog":
            out = "// "
        out += "_LLMHWS_" + base
        if isbegin:
            out += "_BEGIN_"
        else:
            out += "_END_"
        return out

if __name__ == "__main__":
    if len(argv) != 4:
        print("Usage: python " + argv[0] + " <SRC-path> <llm-name> <output-path>")
        exit(1)
    yamlpath = argv[1]
    llmname = argv[2]
    outroot = argv[3]

    with open(yamlpath, "r") as srcin:
        metadata = yaml.safe_load(srcin)
    
    #print(metadata)
    outpaths = []

    srcroot = os.path.dirname(yamlpath)
    for record in metadata:
        path = record["path"]
        units = record["units"]
        sourcepath = os.path.join(srcroot, path)
        pre_ext, extension = os.path.splitext(sourcepath)
        namegen = name_generator(extension[1:])
        for unit_info in units:
            unit = unit_info[0]
            prompt_header = unit_info[1]
            prompt_inline = unit_info[2]
            outpath = os.path.join(outroot, "prompt_" + pre_ext.split(os.path.sep)[-1] + "_" + unit + extension)
            fout = open(outpath, "w")
            # Print the instruction header
            fout.write(f"{prompt_header}\r\n\r\n")
            header_line = namegen.generate_name("HEADER_COMMENT", False)
            unit_begin_line = namegen.generate_name(unit, True)
            unit_end_line = namegen.generate_name(unit, False)
            with open(sourcepath, "r") as fin:
                state = "header"
                for line in fin:
                    _line = line.strip()
                    if state == "header":
                        # Purge the header first
                        if _line == header_line:
                            state = "normal"
                    elif state == "unit":
                        # Wait for the unit to end
                        if _line == unit_end_line:
                            state = "normal"
                    else:
                        # Keep the lines. Meanwhile, wait for the unit to begin
                        if _line == unit_begin_line:
                            # Insert the LLM instruction in lieu of the first line of the unit
                            fout.write(f"-- Instructions for {llmname}: {prompt_inline}\r\n")
                            state = "unit"
                        else:
                            # Only print the lines that are not LLMHWS-related annotations
                            if is_annotation.match(line) == None:
                                fout.write(line)
            fout.close()
            outpaths.append(outpath)
    
    print(f"Generated {len(outpaths)} output files in {outroot}. List: ")
    for path in outpaths:
        print(os.path.abspath(path))