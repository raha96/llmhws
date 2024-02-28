from sys import argv
from explore import load_validate

if __name__ == "__main__":
    if len(argv) != 2:
        print("Usage: " + argv[0] + " <source.yaml>")
        exit(1)
    root = load_validate(argv[1], verbose=True)