
# Extract code blocks, headings, and some of the text from an .Rmd file

import sys, textwrap, re

print()

in_code = False
in_challenge = False
in_omit = False

# Skip yaml header
sys.stdin.readline()
for line in sys.stdin:
    if line.strip() == "---": break

for line in sys.stdin:
    line = line.rstrip()
    if line.startswith("```"):
        print()
        in_code = not in_code
        assert in_code or line == "```" or line == "````", line
    elif in_code:
        line = line.replace("`r ''`","") # Needed in quoted rmarkdown
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
    elif line == "::: {.omit}":
        in_omit = True
    elif line == ":::":
        in_omit = False
    #elif line.startswith("<!---->") or in_challenge:
    elif line and not in_omit:
        # Hack to include some text. Text to be included is marked by an empty comment.
        #if line.startswith("<!---->"):
        #    line = line[7:]

        urls = re.findall(r"\[.*?\]\((.*?)\)", line)
        line = re.sub(r"\[(.*?)\]\(.*?\)", r"\1", line)
        if not in_challenge:
            print()
        for line2 in textwrap.wrap(line, break_on_hyphens=False, break_long_words=False) or [""]:
            print("# " + line2)
        for url in urls:
            print("# " + url)
