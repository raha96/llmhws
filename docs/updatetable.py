import re
import matplotlib.pyplot as plt
import numpy as np

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

def conv_verbosity(val:str) -> str:
    return {"l": "Low", "m": "Medium", "h": "High"}[val.lower()]

def updatetable():
    with open(csvpath, "r") as csvfile:
        title = csvfile.readline().strip().split(",")
        TMP = set()
        for _row in csvfile:
            row = dict(zip(title, _row.strip().split(",")))
            Design = row["Design"]
            Testnum = re.findall(r"\d+", row["Test #"])[0]
            Verbosity = conv_verbosity(row["Prompt Verbosity"])
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
    return chatgpt_table, codellama_table

def updategraphs(table:list, syntax:bool, path:str, title:str):
    if syntax:
        querystr = "Five Attempts - Syntax"
    else:
        querystr = "Five Attempts - Assertion"
    titles = table[0]
    designs = []
    syntax_success_dict = {"Low": {}, "Medium": {}, "High": {}}
    for line in table[2:]:
        record = dict(zip(titles, line))
        Design = record["Design"]
        Verbosity = record["Verbosity"]
        if not Design in designs:
            designs.append(Design)
            syntax_success_dict["Low"][Design] = (0, 0)
            syntax_success_dict["Medium"][Design] = (0, 0)
            syntax_success_dict["High"][Design] = (0, 0)
        olds = syntax_success_dict[Verbosity][Design]
        syntax_success_dict[Verbosity][Design] = (olds[0] + int(record[querystr][:-1]), olds[1] + 1)
    syntax_success = {"Low": [], "Medium": [], "High": []}
    for design in designs:
        for verbosity in syntax_success:
            s = syntax_success_dict[verbosity][design]
            syntax_success[verbosity].append(int(s[0] / s[1]))
    # Now we've got the right data in the right format
    # With help from https://matplotlib.org/stable/gallery/lines_bars_and_markers/barchart.html
    x = np.arange(len(designs))
    width = 0.25
    multiplier = 0
    fig, ax = plt.subplots(layout="constrained")
    colors = ["#ffe840", "#fec44f", "#d95f0e"]
    for attr, meas in syntax_success.items():
        offset = width * multiplier
        rects = ax.bar(x + offset, meas, width, label=attr, color=colors[multiplier%3])
        #ax.bar_label(rects, padding=3)
        multiplier += 1
    #ax.set_ylabel("Syntax Check Success Rate (%)")
    ax.set_title(title, y=1.16)
    ax.set_xticks(x + width, designs)
    ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.22), ncols=len(designs))
    ax.set_ylim(0, 100)
    fig.set_figheight(2.4)
    fig.set_figwidth(6.4)
    plt.savefig(path)

def updatemd(chatgpt_table, codellama_table):
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


chatgpt_table, codellama_table = updatetable()
updategraphs(chatgpt_table, syntax=True, path="assets/syntax-pass-chatgpt.png", title="Syntax Check Success Rate - ChatGPT 3.5 (%)")
updategraphs(chatgpt_table, syntax=False, path="assets/assertion-pass-chatgpt.png", title="Assertion Success Rate - ChatGPT 3.5 (%)")
updategraphs(codellama_table, syntax=True, path="assets/syntax-pass-codellama.png", title="Syntax Check Success Rate - Codellama (%)")
updategraphs(codellama_table, syntax=False, path="assets/assertion-pass-codellama.png", title="Assertion Success Rate - Codellama (%)")
updatemd(chatgpt_table, codellama_table)