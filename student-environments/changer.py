# Script to change the login names from terraform.tfstate.
#
# Put your desired student login names in names.txt, and run this as
#
# $ python changer.py
#
# If the output looks good, redirect to temp file, then overwrite like so:
#
# $ python changer.py > tmp
# $ mv tmp terraform.tfvars
# 

import re

namefile = open('names.txt')

for line in open('terraform.tfvars'):
	if line.startswith('  {'):
		line = re.sub('"[^"]*",', f'"{namefile.readline().strip()}",', line)
	print(line, end='')
