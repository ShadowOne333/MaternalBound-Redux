#!/usr/bin/env python3
import re, sys

if len(sys.argv) != 3:
    print("Usage: python3 replace_flags.py <definitions_file> <target_file>", file=sys.stderr)
    sys.exit(1)

defs_file, target_file = sys.argv[1], sys.argv[2]

# Build mapping num -> NAME
map_re = re.compile(r'^\s*define\s+([A-Za-z0-9_]+)\s*=\s*flag\s+(\d+)\b', re.IGNORECASE)
num_to_name = {}
with open(defs_file, 'r', encoding='utf-8') as f:
    for line in f:
        m = map_re.match(line)
        if m:
            name, num = m.group(1), m.group(2)
            num_to_name[num] = name

# Replace only set(flag N) and unset(flag N) (allow spaces)
pattern = re.compile(r'^(?P<prefix>\s*)(?P<cmd>set|unset)\s*\(\s*flag\s+(?P<num>\d+)\s*\)\s*(?P<rest>//.*)?$',
                     re.IGNORECASE | re.MULTILINE)

def repl(m):
    prefix = m.group('prefix') or ''
    cmd = m.group('cmd')
    num = m.group('num')
    name = num_to_name.get(num)
    inner = name if name else f'flag {num}'
    # Keep any existing trailing comment that's not a numeric flag; but always ensure " //N" is present at end.
    return f"{prefix}{cmd}({inner})\t// {num}"

text = open(target_file, 'r', encoding='utf-8').read()
out = pattern.sub(repl, text)
sys.stdout.write(out)

