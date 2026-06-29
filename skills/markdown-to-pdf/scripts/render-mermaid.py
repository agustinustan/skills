#!/usr/bin/env python3
from pathlib import Path
import re
import subprocess
import sys


def render_mermaid_blocks(source: Path, output: Path) -> None:
    text = source.read_text(encoding="utf-8")
    pattern = re.compile(r"```mermaid[ \t]*\n(.*?)\n```", re.IGNORECASE | re.DOTALL)
    work_dir = Path("/tmp/markdown-to-pdf-mermaid")
    work_dir.mkdir(parents=True, exist_ok=True)

    replacements: list[tuple[tuple[int, int], str]] = []
    for index, match in enumerate(pattern.finditer(text), start=1):
        diagram = match.group(1).strip()
        if not diagram:
            print(f"mermaid diagram {index} is empty", file=sys.stderr)
            sys.exit(31)

        input_file = work_dir / f"diagram-{index}.mmd"
        svg_file = work_dir / f"diagram-{index}.svg"
        input_file.write_text(diagram + "\n", encoding="utf-8")
        result = subprocess.run(
            ["mmdc", "-i", str(input_file), "-o", str(svg_file), "-b", "transparent"],
            text=True,
            capture_output=True,
            check=False,
        )
        if result.returncode != 0 or not svg_file.exists() or svg_file.stat().st_size == 0:
            details = (result.stderr or result.stdout).strip()
            print(f"mermaid diagram {index} failed to render", file=sys.stderr)
            if details:
                print(details, file=sys.stderr)
            sys.exit(32)

        replacements.append((match.span(), f"![Mermaid diagram {index}]({svg_file})"))

    rendered = text
    for (start, end), replacement in reversed(replacements):
        rendered = rendered[:start] + replacement + rendered[end:]
    output.write_text(rendered, encoding="utf-8")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: render-mermaid.py <source.md> <output.md>", file=sys.stderr)
        sys.exit(2)
    render_mermaid_blocks(Path(sys.argv[1]), Path(sys.argv[2]))
