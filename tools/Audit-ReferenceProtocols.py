"""Generate a source index, not a proof that each protocol is implemented.

Reads reference Python comparisons and local Go source. No network, database,
client, deployment, or mutation beyond the requested CSV output.
"""
import argparse
import ast
import csv
import re
from pathlib import Path


def collect(reference):
    entries = {}
    for path in sorted(reference.rglob("*.py")):
        tree = ast.parse(path.read_text(encoding="utf-8-sig"))
        for node in ast.walk(tree):
            if not isinstance(node, ast.Compare):
                continue
            left = node.left
            named = isinstance(left, ast.Name) and left.id in {"ident", "identifier"}
            keyed = isinstance(left, ast.Subscript) and isinstance(left.slice, ast.Constant) and left.slice.value == "id"
            if not (named or keyed):
                continue
            for comparator in node.comparators:
                for value in ast.walk(comparator):
                    if isinstance(value, ast.Constant) and type(value.value) is int and 1000 <= value.value < 30000:
                        evidence = f"{path.relative_to(reference).as_posix()}:{node.lineno}"
                        entries.setdefault(value.value, set()).add(evidence)
    return entries


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--go", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    entries = collect(args.reference)
    sources = [(p, p.read_text(encoding="utf-8-sig")) for p in sorted(args.go.rglob("*.go")) if not p.name.endswith("_test.go")]
    with args.output.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["protocol_id", "reference_locations", "go_literal_locations", "interpretation"])
        for ident, evidence in sorted(entries.items()):
            pattern = re.compile(r"\b" + str(ident) + r"\b")
            local = [f"{p.relative_to(args.go).as_posix()}:{n}" for p, text in sources for n, line in enumerate(text.splitlines(), 1) if pattern.search(line)]
            writer.writerow([ident, "; ".join(sorted(evidence)), "; ".join(local), "Source index only: may be decoder/output/logging/constant, not a handler. See protocol-audit-20260922.md."])
    print(f"Indexed {len(entries)} protocol identifiers: {args.output}")


if __name__ == "__main__":
    main()
