import sys, re

# adjust these:
input_path = sys.argv[1]
output_path = sys.argv[2]
item_name = 'item_name_in_quotes'   # include quotes if you want them, e.g. '"my_item"'

# match '" <[1C 05 XX]>"' optionally followed by whitespace and the word 'next'
pattern = re.compile(r'" <\[1C 05 ([0-9A-Fa-f]{2})\]>"(?:\s*next)?')

def hex_to_dec_comment(m):
    hexbyte = m.group(1)
    dec = int(hexbyte, 16)
    return f'{item_name}({dec})\t// 0x{hexbyte.upper()}'

with open(input_path, "r", encoding="utf-8") as f:
    s = f.read()

s2 = pattern.sub(hex_to_dec_comment, s)

with open(output_path, "w", encoding="utf-8") as f:
    f.write(s2)
