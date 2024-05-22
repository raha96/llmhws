import tkinter as tk
from tkinter import messagebox
from sys import argv
from explore import load_validate
from custom_dump import dump
from idlelib.tooltip import Hovertip

# Fields: 
#   Plain -> plain
#   Threat -> threat
#   WeaknessClassification -> weakclass
#   VulnerabilityClassification -> vulnclass
#   Tool -> tool
#   Assertions -> assertions
#   Design -> design
#   Origin -> origin
#   Reference -> reference

def list_the_unexpected(record:dict) -> dict:
    unex = {}
    # The expected: 
    if "plain" in record:
        assert "Plain" not in record
        _ex = ["plain", "threat", "weakclass", "vulnclass", 
            "tool", "assertions", "design", "origin", 
            "reference"]
    elif "Plain" in record:
        assert "plain" not in record
        _ex = ["ID", "Plain", "Threat", "WeaknessClassification", 
            "VulnerabilityClassification", "Tool", "Assertions", 
            "Design", "Origin", "Reference"]
    else:
        assert False
    for key in record:
        if not key in _ex:
            unex[key] = record[key]
    return unex

def unpack_data(data:list) -> tuple:
    """Returns a (list,dict) pair containing sorted list of IDs and the ID -> record dict"""
    unpacked = {}
    ids = []
    for record in data:
        ID = record["ID"]
        ids.append(ID)
        unpacked[ID] = {
            "plain": record["Plain"],
            "threat": record["Threat"] if record["Threat"] else " ",
            "weakclass": record["WeaknessClassification"] if record["WeaknessClassification"] else [" "],
            "vulnclass": record["VulnerabilityClassification"] if record["VulnerabilityClassification"] else [" "],
            "tool": record["Tool"] if ("Tool" in record and record["Tool"]) else " ",
            "assertions": record["Assertions"] if record["Assertions"] else " ",
            "design": record["Design"] if record["Design"] else " ",
            "origin": record["Origin"] if record["Origin"] else " ",
            "reference": record["Reference"] if record["Reference"] else " "
        }
        unex = list_the_unexpected(record)
        for key in unex:
            unpacked[ID][key] = unex[key]
        #print(f"{ID}: {unpacked[ID]['weakclass']}")
    ids.sort()
    return ids, unpacked

def pack_data(ids:list, unpacked:dict) -> list:
    """Gets the id list and the unpacked data and returns a packed dict, ready to be custom-dumped"""
    packed = []
    for id in ids:
        record = {
            "ID": id, 
            "Plain": unpacked[id]["plain"], 
            "Threat": unpacked[id]["threat"], 
            "WeaknessClassification": unpacked[id]["weakclass"], 
            "VulnerabilityClassification": unpacked[id]["vulnclass"], 
            "Tool": unpacked[id]["tool"], 
            "Assertions": unpacked[id]["assertions"], 
            "Design": unpacked[id]["design"], 
            "Origin": unpacked[id]["origin"], 
            "Reference": unpacked[id]["reference"]
        }
        unex = list_the_unexpected(unpacked[id])
        for key in unex:
            record[key] = unex[key]
        #record = {**{"ID": id}, **unpacked[id]}
        packed.append(record)
    return packed

def extract_list_from_text(text:str) -> list:
    toks = text.split(",")
    out = []
    if toks[0].strip().isnumeric():
        for x in toks:
            out.append(int(x.strip()))
    else:
        for x in toks:
            out.append(x.strip())
    return out

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: python " + argv[0] + " <source.yaml>")
        exit(1)
    
    source_file = argv[1]
    data = load_validate(source_file)
    ids, data = unpack_data(data)
    currentid_index = 0

    window = tk.Tk()
    window.wm_title("LLMHWS Explorer")
    window.columnconfigure(index=1, weight=1)
    window.rowconfigure(index=1, weight=1)
    window.rowconfigure(index=6, weight=1)

    lblid = tk.Label(text="ID: ")
    txtid = tk.Entry()
    lblid.grid(row=0, column=0, sticky="e", padx=2, pady=2)
    txtid.grid(row=0, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipid = Hovertip(txtid, "Unique record ID")

    lblplain = tk.Label(text="Plain text vulnerability: ")
    txtplain = tk.Text()
    sclplain = tk.Scrollbar(command=txtplain.yview)
    txtplain["yscrollcommand"] = sclplain.set
    lblplain.grid(row=1, column=0, sticky="ne", padx=2, pady=2)
    txtplain.grid(row=1, column=1, sticky="news", padx=2, pady=2)
    sclplain.grid(row=1, column=2, sticky="news", padx=2, pady=2)
    tipplain = Hovertip(txtplain, "Plain text description of the security vulnerability")

    lblthreat = tk.Label(text="Threat: ")
    txtthreat = tk.Entry()
    lblthreat.grid(row=2, column=0, sticky="e", padx=2, pady=2)
    txtthreat.grid(row=2, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipthreat = Hovertip(txtthreat, "Threat model description")

    lblweakclass = tk.Label(text="Weakness classification: ")
    txtweakclass = tk.Entry()
    lblweakclass.grid(row=3, column=0, sticky="e", padx=2, pady=2)
    txtweakclass.grid(row=3, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipweakclass = Hovertip(txtweakclass, "e.g. CWE classification")

    lblvulnclass = tk.Label(text="Vulnerability classification: ")
    txtvulnclass = tk.Entry()
    lblvulnclass.grid(row=4, column=0, sticky="e", padx=2, pady=2)
    txtvulnclass.grid(row=4, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipvulnclass = Hovertip(txtvulnclass, "e.g. CAPEC classification")

    lbltool = tk.Label(text="Tool: ")
    txttool = tk.Entry()
    lbltool.grid(row=5, column=0, sticky="e", padx=2, pady=2)
    txttool.grid(row=5, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tiptool = Hovertip(txttool, "The software tool needed for verifying the assertions, e.g. Cadence JasperGold")

    lblassertions = tk.Label(text="Assertions: ")
    txtassertions = tk.Text()
    sclassertions = tk.Scrollbar(command=txtassertions.yview)
    txtassertions["yscrollcommand"] = sclassertions.set
    lblassertions.grid(row=6, column=0, sticky="ne", padx=2, pady=2)
    txtassertions.grid(row=6, column=1, sticky="news", padx=2, pady=2)
    sclassertions.grid(row=6, column=2, sticky="news", padx=2, pady=2)
    tipassertions = Hovertip(txtassertions, "Security assertions for verifying the code against this vulnerability (e.g. SV assertions)")

    lbldesign = tk.Label(text="Design: ")
    txtdesign = tk.Entry()
    lbldesign.grid(row=7, column=0, sticky="e", padx=2, pady=2)
    txtdesign.grid(row=7, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipdesign = Hovertip(txtdesign, "Design name or path. In case the design is available in this repo, use the format `PATH:` + relative path")

    lblorigin = tk.Label(text="Origin: ")
    txtorigin = tk.Entry()
    lblorigin.grid(row=8, column=0, sticky="e", padx=2, pady=2)
    txtorigin.grid(row=8, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tiporigin = Hovertip(txtorigin, "Reference to the original data source (e.g. paper or database)")

    lblreference = tk.Label(text="Reference: ")
    txtreference = tk.Entry()
    lblreference.grid(row=9, column=0, sticky="e", padx=2, pady=2)
    txtreference.grid(row=9, column=1, sticky="news", padx=2, pady=2, columnspan=2)
    tipreference = Hovertip(txtreference, "Reference to the vulnerability or weakness (e.g. URL)")

    def set_text_value(textbox, value:str):
        if type(textbox) is tk.Entry:
            textbox.delete(0, tk.END)
            textbox.insert(0, value)
        elif type(textbox) is tk.Text:
            textbox.delete(1.0, tk.END)
            textbox.insert(tk.END, value)
        else:
            raise f"Unhandled case for textbox of type {type(textbox)}"

    def display_record():
        if txtid.get() == "":
            set_text_value(txtid, str(ids[currentid_index]))
        cid = int(txtid.get())
        set_text_value(txtplain, data[cid]["plain"])
        set_text_value(txtthreat, data[cid]["threat"])
        set_text_value(txtweakclass, ", ".join(data[cid]["weakclass"]))
        set_text_value(txtvulnclass, ", ".join([str(x) for x in data[cid]["vulnclass"]]))
        set_text_value(txttool, data[cid]["tool"])
        set_text_value(txtassertions, data[cid]["assertions"])
        set_text_value(txtdesign, data[cid]["design"])
        set_text_value(txtorigin, data[cid]["origin"])
        set_text_value(txtreference, data[cid]["reference"])

    def onclick_prev():
        global currentid_index
        currentid_index -= 1
        if currentid_index < 0:
            currentid_index = len(ids) - 1
        set_text_value(txtid, "")
        display_record()

    def onclick_next():
        global currentid_index
        currentid_index += 1
        if currentid_index >= len(ids):
            currentid_index = 0
        set_text_value(txtid, "")
        display_record()

    def onclick_load():
        global currentid_index
        cid = int(txtid.get())
        if not cid in ids:
            messagebox.showerror(message=f"Invalid ID `{cid}`")
        else:
            currentid_index = ids.index(cid)
            display_record()

    def onclick_save():
        # Expected behavior: If the user uses an unused ID, it will be dealt with as a new record in the dataset. 
        ID = int(txtid.get())
        datalen = len(data)
        newrecord = {
            "plain": txtplain.get("1.0", tk.END), 
            "threat": txtthreat.get(), 
            "weakclass": extract_list_from_text(txtweakclass.get()), 
            "vulnclass": extract_list_from_text(txtvulnclass.get()),  
            "tool": txttool.get(), 
            "assertions": txtassertions.get("1.0", tk.END), 
            "design": txtdesign.get(), 
            "origin": txtorigin.get(), 
            "reference": txtreference.get()
        }
        if ID in data:
            unex = list_the_unexpected(data[ID])
            for key in unex:
                newrecord[key] = unex[key]
        else:
            ids.append(ID)
            ids.sort()
        data[ID] = newrecord
        packed = pack_data(ids, data)
        with open(source_file, "w") as fout:
            fout.write(dump(packed))
        datalen = len(data) - datalen
        messagebox.showinfo(message=f"Successfully updated the dataset. {datalen if datalen else 'No'} new record added. ")

    frmbuttons = tk.Frame()
    btnprev = tk.Button(frmbuttons, text="<", command=onclick_prev)
    btnnext = tk.Button(frmbuttons, text=">", command=onclick_next)
    btnload = tk.Button(frmbuttons, text="Load", command=onclick_load)
    btnsave = tk.Button(frmbuttons, text="Save", command=onclick_save)
    btnprev.grid(row=0, column=0, sticky="news", padx=2, pady=2)
    btnnext.grid(row=0, column=1, sticky="news", padx=2, pady=2)
    btnload.grid(row=0, column=2, sticky="news", padx=2, pady=2)
    btnsave.grid(row=0, column=3, sticky="news", padx=2, pady=2)
    frmbuttons.grid(row=10, column=0, columnspan=3)

    window.geometry("600x400")

    display_record()

    window.mainloop()