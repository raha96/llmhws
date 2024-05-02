import re
csvpath = "assets/RawData.csv"
mdpath = "index.markdown"

chatgpt_table = [
    ["Design", "Test #", "Verbosity", "# Lines", "First Attempt - Syntax", "First Attempt - Assertion", "Five Attempts - Syntax", "Five Attempts - Assertion"], 
    ["------", "------", "---------", "-------", "----------------------", "-------------------------", "----------------------", "-------------------------"], 
]
codellama_table = [
    ["Design", "Test #", "Verbosity", "# Lines", "First Attempt - Syntax", "First Attempt - Assertion", "Five Attempts - Syntax", "Five Attempts - Assertion"], 
    ["------", "------", "---------", "-------", "----------------------", "-------------------------", "----------------------", "-------------------------"]
]

def unify(val:str) -> str:
    if val.strip().lower() in ["✓", "passed"]:
        return "✓"
    if val.strip().lower() in ["pure text", "no code"]:
        return "No Code"
    if val.strip().lower() in ["unverified", "no cover"]:
        return "No Cover"
    return "✗"

with open(csvpath, "r") as csvfile:
    title = csvfile.readline().strip().split(",")
    TMP = set()
    for _row in csvfile:
        row = dict(zip(title, _row.strip().split(",")))
        Design = row["Design"]
        Testnum = re.findall(r"\d+", row["Test #"])[0]
        Verbosity = row["Prompt Verbosity"]
        NumLines = row["# of missing Lines"]
        ChatGPT35_FirstSyn = unify(row["ChatGPT3.5-R1-Syntax"])
        ChatGPT35_FirstAss = unify(row["ChatGPT3.5-R1-FPV"])
        ChatGPT35_FiveSyns = 0
        ChatGPT35_FiveAsss = 0
        for i in [1, 2, 3, 4, 5]:
            ChatGPT35_FiveSyns += int(unify(row[f"ChatGPT3.5-R{i}-Syntax"]) == "✓")
            ChatGPT35_FiveAsss += int(unify(row[f"ChatGPT3.5-R{i}-FPV"]) == "✓")
            TMP.add(row[f"ChatGPT3.5-R{i}-Syntax"])
            TMP.add(row[f"ChatGPT3.5-R{i}-FPV"])
        ChatGPT35_FiveSyns = f"{20 * ChatGPT35_FiveSyns}%"
        ChatGPT35_FiveAsss = f"{20 * ChatGPT35_FiveAsss}%"
        Codellama_FirstSyn = unify(row["Codellama-R1-Syntax"])
        Codellama_FirstAss = unify(row["Codellama-R1-FPV"])
        Codellama_FiveSyns = 0
        Codellama_FiveAsss = 0
        for i in [1, 2, 3, 4, 5]:
            Codellama_FiveSyns += int(unify(row[f"Codellama-R{i}-Syntax"]) == "✓")
            Codellama_FiveAsss += int(unify(row[f"Codellama-R{i}-FPV"]) == "✓")
            TMP.add(row[f"Codellama-R{i}-Syntax"])
            TMP.add(row[f"Codellama-R{i}-FPV"])
        Codellama_FiveSyns = f"{20 * Codellama_FiveSyns}%"
        Codellama_FiveAsss = f"{20 * Codellama_FiveAsss}%"
        chatgpt_table.append([
            Design, 
            Testnum, 
            Verbosity, 
            NumLines, 
            ChatGPT35_FirstSyn, 
            ChatGPT35_FirstAss, 
            ChatGPT35_FiveSyns, 
            ChatGPT35_FiveAsss
        ])
        codellama_table.append([
            Design, 
            Testnum, 
            Verbosity, 
            NumLines, 
            Codellama_FirstSyn, 
            Codellama_FirstAss, 
            Codellama_FiveSyns, 
            Codellama_FiveAsss
        ])

print(TMP)

linebuf = []
with open(mdpath, "r") as mdin:
    line = ""
    found = False
    while not found:
        line = mdin.readline()
        if line.strip() == "## State of Benchmarking - ChatGPT 3.5":
            found = True
        else:
            linebuf.append(line)

assert found

with open(mdpath, "w") as mdout:
    for line in linebuf:
        mdout.write(line)
    mdout.write("## State of Benchmarking - ChatGPT 3.5\n")
    mdout.write('{:style="text-align:center;"}\n\n')
    for row in chatgpt_table:
        mdout.write("| " + (" | ".join(row)) + " |\n")
    mdout.write("\n\n## State of Benchmarking - Codellama\n")
    mdout.write('{:style="text-align:center;"}\n\n')
    for row in codellama_table:
        mdout.write("| " + (" | ".join(row)) + " |\n")