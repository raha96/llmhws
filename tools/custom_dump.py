def dump(root:list) -> str:
    def format_text(_val:str, linelen:int=110, indent="  ") -> str:
        """Meant for long plain text"""
        if _val and len(_val.strip()):
            _toks = _val.split()
            _cline = indent * 2
            _lines = []
            for _tok in _toks:
                if len(_cline) < linelen:
                    _cline += _tok + " "
                else:
                    _lines.append(_cline)
                    _cline = (indent * 2) + _tok + " "
            _lines.append(_cline)
            return "\n".join(_lines) + "\n"
        return ""
    def format_code(_val:str, indent="  ") -> str:
        """Meant for code blocks"""
        if _val and len(_val.strip()):
            _lines_orig = _val.split("\n")
            _lines_out = []
            for _line in _lines_orig:
                if len(_line.strip()):
                    _lines_out.append(indent * 2 + _line)
            _out = "\n".join(_lines_out)
            if _out[-1] != "\n":
                _out += "\n"
            return _out
        return ""
    def format_string(_val:str) -> str:
        if _val and len(_val.strip()):
            return f'"{_val}"'
        return ""
    def format_list(_val:list) -> str:
        if _val and len(_val):
            out = []
            for x in _val:
                if type(x) is str:
                    if len(x.strip()):
                        out.append(format_string(x))
                else:
                    out.append(str(x))
            if len(out):
                return f"[{', '.join(out)}]"
            else:
                return ""
        return ""
    def ifex(record:dict, key:str):
        """Retrieve if exists, else a safe fallback value"""
        if key in record:
            return record[key]
        else:
            return ""
    def list_the_unexpected(record:dict) -> dict:
        unex = {}
        # The expected: 
        _ex = ["ID", "Plain", "Threat", "WeaknessClassification", 
            "VulnerabilityClassification", "Tool", "Assertions", 
            "Design", "Origin", "Reference"]
        for key in record:
            if not key in _ex:
                unex[key] = record[key]
        return unex

    out = ""
    for record in root:
        out += "- ID: {}\n".format(str(record["ID"]))
        out += "  Plain: >-\n{}".format(format_text(record["Plain"]))
        out += "  Threat: {}\n".format(format_string(ifex(record, "Threat")))
        out += "  WeaknessClassification: {}\n".format(format_list(record["WeaknessClassification"]))
        out += "  VulnerabilityClassification: {}\n".format(format_list(record["VulnerabilityClassification"]))
        out += "  Tool: {}\n".format(format_string(ifex(record, "Tool")))
        out += "  Assertions: |-\n{}".format(format_code(record["Assertions"]))
        out += "  Design: {}\n".format(format_string(record["Design"]))
        out += "  Origin: {}\n".format(format_string(record["Origin"]))
        out += "  Reference: {}\n".format(format_string(record["Reference"]))
        # The "expected" attributes were dumped in the original order. The 
        # "unexpected" ones will be just extracted and dumped in any order. 
        unex = list_the_unexpected(record)
        for key in unex:
            out += "  {}: {}\n".format(key, format_string(record[key]))
        out += "\n"
    return out