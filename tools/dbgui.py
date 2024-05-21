import tkinter as tk
from tkinter import messagebox
from sys import argv
from explore import load_validate

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

def reframe_data(data:list) -> tuple:
    """Returns a (list,dict) pair containing sorted list of IDs and the ID -> record dict"""
    reframed = {}
    ids = []
    for record in data:
        ID = record["ID"]
        ids.append(ID)
        reframed[ID] = {
            "plain": record["Plain"],
            "threat": record["Threat"],
            "weakclass": record["WeaknessClassification"] if record["WeaknessClassification"] else [" "],
            "vulnclass": record["VulnerabilityClassification"] if record["VulnerabilityClassification"] else [" "],
            "tool": record["Tool"] if "Tool" in record else " ",
            "assertions": record["Assertions"] if record["Assertions"] else " ",
            "design": record["Design"] if record["Design"] else " ",
            "origin": record["Origin"] if record["Origin"] else " ",
            "reference": record["Reference"] if record["Reference"] else " "
        }
        #print(f"{ID}: {reframed[ID]['weakclass']}")
    ids.sort()
    return ids, reframed

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: python " + argv[0] + " <source.yaml>")
        exit(1)
    
    data = load_validate(argv[1])
    ids, data = reframe_data(data)
    currentid_index = 0

    window = tk.Tk()
    window.wm_title("LLMHWS Explorer")
    window.columnconfigure(index=1, weight=1)
    window.rowconfigure(index=1, weight=1)
    window.rowconfigure(index=6, weight=1)

    lblid = tk.Label(text="ID: ")
    txtid = tk.Entry()
    lblid.grid(row=0, column=0, sticky="e", padx=2, pady=2)
    txtid.grid(row=0, column=1, sticky="news", padx=2, pady=2)

    lblplain = tk.Label(text="Plain text vulnerability: ")
    txtplain = tk.Text()
    lblplain.grid(row=1, column=0, sticky="ne", padx=2, pady=2)
    txtplain.grid(row=1, column=1, sticky="news", padx=2, pady=2)

    lblthreat = tk.Label(text="Threat: ")
    txtthreat = tk.Entry()
    lblthreat.grid(row=2, column=0, sticky="e", padx=2, pady=2)
    txtthreat.grid(row=2, column=1, sticky="news", padx=2, pady=2)

    lblweakclass = tk.Label(text="Weakness classification: ")
    txtweakclass = tk.Entry()
    lblweakclass.grid(row=3, column=0, sticky="e", padx=2, pady=2)
    txtweakclass.grid(row=3, column=1, sticky="news", padx=2, pady=2)

    lblvulnclass = tk.Label(text="Vulnerability classification: ")
    txtvulnclass = tk.Entry()
    lblvulnclass.grid(row=4, column=0, sticky="e", padx=2, pady=2)
    txtvulnclass.grid(row=4, column=1, sticky="news", padx=2, pady=2)

    lbltool = tk.Label(text="Tool: ")
    txttool = tk.Entry()
    lbltool.grid(row=5, column=0, sticky="e", padx=2, pady=2)
    txttool.grid(row=5, column=1, sticky="news", padx=2, pady=2)

    lblassertions = tk.Label(text="Assertions: ")
    txtassertions = tk.Text()
    lblassertions.grid(row=6, column=0, sticky="ne", padx=2, pady=2)
    txtassertions.grid(row=6, column=1, sticky="news", padx=2, pady=2)

    lbldesign = tk.Label(text="Design: ")
    txtdesign = tk.Entry()
    lbldesign.grid(row=7, column=0, sticky="e", padx=2, pady=2)
    txtdesign.grid(row=7, column=1, sticky="news", padx=2, pady=2)

    lblorigin = tk.Label(text="Origin: ")
    txtorigin = tk.Entry()
    lblorigin.grid(row=8, column=0, sticky="e", padx=2, pady=2)
    txtorigin.grid(row=8, column=1, sticky="news", padx=2, pady=2)

    lblreference = tk.Label(text="Reference: ")
    txtreference = tk.Entry()
    lblreference.grid(row=9, column=0, sticky="e", padx=2, pady=2)
    txtreference.grid(row=9, column=1, sticky="news", padx=2, pady=2)

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
        set_text_value(txtreference, "Save")

    frmbuttons = tk.Frame()
    btnprev = tk.Button(frmbuttons, text="<", command=onclick_prev)
    btnnext = tk.Button(frmbuttons, text=">", command=onclick_next)
    btnload = tk.Button(frmbuttons, text="Load", command=onclick_load)
    btnsave = tk.Button(frmbuttons, text="Save", command=onclick_save)
    btnprev.grid(row=0, column=0, sticky="news", padx=2, pady=2)
    btnnext.grid(row=0, column=1, sticky="news", padx=2, pady=2)
    btnload.grid(row=0, column=2, sticky="news", padx=2, pady=2)
    btnsave.grid(row=0, column=3, sticky="news", padx=2, pady=2)
    frmbuttons.grid(row=10, column=0, columnspan=2)

    window.geometry("600x400")

    display_record()

    window.mainloop()