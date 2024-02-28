import yaml
from sys import argv

expected_fields = set([
    "ID", "Plain", "Threat", "CWE", "CAPEC", "Assertions", "Design", "Origin", "Reference", "Tool"
])
expected_types = {
    "ID": int, 
    "Plain": str, 
    "Threat": str, 
    "CWE": int, 
    "CAPEC": int, 
    "Assertions": str, 
    "Design": str, 
    "Origin": str, 
    "Reference": str, 
    "Tool": str
}

def load_validate(path:str, verbose:bool=False):
    with open(path, "r") as fin:
        root = yaml.safe_load(fin)
    assert type(root) == list, "Invalid YAML format: The root must be a list"
    ids = []
    for record in root:
        assert "ID" in record, "Invalid record: Every record must have an ID"
        id = record["ID"]
        assert type(id) == int, f"Invalid record: Expected integer ID, found {type(id)} instead (@ ID = `{id}`)"
        if id in ids:
            if (verbose):
                print(f"Warning: Duplicate ID {id}")
        else:
            ids.append(id)
        assert type(record) == dict, f"Invalid YAML format: Expected dict type for the record, found {type(record)} instead (@ ID = `{id}`)"
        # Check the datatypes for all records
        missing = []
        for field in expected_fields:
            if (not field in record) or (record[field] is None) or (type(record[field]) == int and record[field] == -1):
                missing.append(field)
            else:
                if type(record[field]) != expected_types[field]:
                    if (verbose):
                        print(f"Warning: Expected type {expected_types[field]} for the field {field}, found {type(record[field])} instead (@ ID = `{id}`)")
        if len(missing):
            if (verbose):
                print(f"Info: Fields {missing} missing (@ ID = `{id}`)")
        extra = []
        for field in record:
            if not field in expected_fields:
                extra.append(field)
        if len(extra):
            if (verbose):
                print(f"Info: Extra fields {extra} found (@ ID = `{id}`)")
    return root

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: " + argv[0] + " <source.yaml>")
        exit(1)
    root = load_validate(argv[1])