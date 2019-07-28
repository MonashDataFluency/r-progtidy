
# Extract code blocks from an .Rmd file

import sys, textwrap

print("# This file is generated from the corresponding .Rmd file")
print()
print()

in_code = False
in_challenge = False
for line in sys.stdin:
    line = line.rstrip()
    if line.startswith("```"):
        print()
        in_code = not in_code
        assert in_code or line == "```", line
    elif in_code:
        print(line)
    elif line.startswith("#"):
        print("#" if in_challenge else "")
        in_challenge = "{.challenge}" in line
        if in_challenge:
            line = line.replace("{.challenge}","").rstrip()
        n = line.count("#")
        line = line[n:].strip()
        left = "#"*n+" "
        bracket = "----" if n > 1 else "===="
        print(left+"_"*(n-1+len(line)+len(bracket)*2+2))
        print(left+bracket+">"*(n-1)+" "+line+" "+bracket)
    elif in_challenge:
        for line2 in textwrap.wrap(line) or [""]:
            print("# " + line2)
