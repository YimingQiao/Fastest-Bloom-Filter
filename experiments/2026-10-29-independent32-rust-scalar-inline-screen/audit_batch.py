"""Read the frozen executable's before/after public batch entries; never run it."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path, required=True)
    args = parser.parse_args()
    binary = args.binary.resolve()
    symbols = subprocess.check_output(["nm", "-C", str(binary)], text=True)
    text_symbols = []
    for line in symbols.splitlines():
        match = re.match(r"([0-9a-f]+) [tT] (.+)", line)
        if match:
            text_symbols.append((int(match[1], 16), match[2]))
    text_symbols.sort()
    selected = []
    for i, (start, name) in enumerate(text_symbols):
        if (("independent32_native_experiment" in name or "independent32_singleton_experiment" in name or "independent32_scalar_inline_experiment" in name)
                and ("::lookup::<" in name or "::lookup_hashes" in name)):
            end = next(address for address, _ in text_symbols[i + 1:] if address > start)
            command = ["objdump", "-d", "--demangle", "--no-show-raw-insn", f"--start-address={start:#x}", f"--stop-address={end:#x}", str(binary)]
            body = subprocess.check_output(command, text=True)
            selected.append(dict(start=hex(start), end=hex(end), symbol=name, body=body, command=command))
    if len(selected) != 6:
        raise ValueError("Expected three generic wrappers and three public batch entries")
    out = HERE / "assembly"
    (out / "generic-batch-before-after.txt").write_text("\n".join(entry["body"] for entry in selected))
    for entry in selected:
        del entry["body"]
    (out / "generic-batch-inventory.json").write_text(json.dumps(dict(binary=str(binary), binary_sha256=hashlib.sha256(binary.read_bytes()).hexdigest(),
                                                                     entries=selected, timing_executed=False), indent=2) + "\n")
    print("Archived unchanged-binary before/after generic/public batch assembly; no execution")


if __name__ == "__main__":
    main()
