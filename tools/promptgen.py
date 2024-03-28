from sys import argv
import yaml
import os
import re
import shutil

is_annotation = re.compile(r"\s*(--|//) *_LLMHWS_(.+)_(BEGIN|END)_")

def detect_file_type(extension:str) -> str:
        extension = extension.lower()
        if extension == "vhd":
            return "vhdl"
        elif extension == "v" or extension == "sv":
            return "verilog"
        else:
            raise f"Unsupported file extension `{extension}`"

class commenter: 
    def __init__(self, extension:str):
        self.language = detect_file_type(extension)
    def comment(self, line:str) -> str:
        out = ""
        if self.language == "vhdl":
            out = "-- " + line
        elif self.language == "verilog":
            out = "// " + line
        return out

class name_generator:
    def __init__(self, extension:str):
        self._commenter = commenter(extension)
    def generate_name(self, base:str, isbegin:bool) -> str:
        out = "_LLMHWS_" + base
        if isbegin:
            out += "_BEGIN_"
        else:
            out += "_END_"
        return self._commenter.comment(out)

def check_design_folder(path:str) -> bool:
    out = True
    _ls = os.listdir(path)
    if "SRC" not in _ls:
        print(f"Error: `SRC` not found in path `{path}`. It must be a YAML file containing information about the code fragments marked for omission. ")
        out = False
    if "ORIGIN" not in _ls:
        print(f"Error: `ORIGIN` not found in path `{path}`. It should be a text file containing an absolute URL pointing to the reference. ")
        out = False
    if "properties" not in _ls:
        print(f"Error: `properties` folder not found in path `{path}. It should contain the SystemVerilog files describing the security assertions. ")
        out = False
    if "src" not in _ls:
        print(f"Error: `src` folder not found in path `{path}`. It should contain the original design source code. ")
        out = False
    if "prove.tcl" not in _ls:
        print(f"Error: `prove.tcl` not found in path `{path}`. It should contain a tcl script verifying the assertions when invoked via proper tools. ")
        out = False
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
    if not check_design_folder(srcroot):
        print("Terminating due to an error. For more information, refer to the documentation in the GitHub repo. ")
        exit(1)
    else:
        print("Found all required files, proceeding...")
    
    for record in metadata:
        path = record["path"]
        units = record["units"]
        promptdict = record["prompts"]
        sourcepath = os.path.join(srcroot, path)
        pre_ext, extension = os.path.splitext(sourcepath)
        namegen = name_generator(extension[1:])
        commentgen = commenter(extension[1:])
        for verbosity in promptdict:
            prompt_header = promptdict[verbosity]
            for unit_info in units:
                unit = unit_info[0]
                prompt_inline = unit_info[1]

                # Make the base directory
                localoutroot = os.path.join(outroot, unit + "_" + verbosity)
                if os.path.exists(localoutroot):
                    shutil.rmtree(localoutroot)
                os.mkdir(localoutroot)
                # Copy the original source files to the destination, excluding SRC
                shutil.copy(os.path.join(srcroot, "ORIGIN"), localoutroot)
                shutil.copy(os.path.join(srcroot, "prove.tcl"), localoutroot)
                shutil.copytree(os.path.join(srcroot, "properties"), os.path.join(localoutroot, "properties"))
                shutil.copytree(os.path.join(srcroot, "src"), os.path.join(localoutroot, "src"))

                outpath = os.path.join(outroot, "prompt_" + verbosity + "_" + pre_ext.split(os.path.sep)[-1] + "_" + unit + extension)
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
                                fout.write(commentgen.comment(f"Instructions for {llmname}: {prompt_inline}\r\n"))
                                state = "unit"
                            else:
                                # Only print the lines that are not LLMHWS-related annotations
                                if is_annotation.match(line) == None:
                                    fout.write(line)
                fout.close()
                outpaths.append(outpath)
    
    print(f"Generated {len(outpaths)} output folders in {outroot}. List: ")
    for path in outpaths:
        print(os.path.abspath(path))