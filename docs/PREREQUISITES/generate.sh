#! /usr/bin/env bash
# generates docs/PREREQUISITES/README.md
SCRIPT="$(readlink -f $0)"
PARENT="$(dirname $(dirname ${SCRIPT%/*}))"
PREREQ="$PARENT/docs/PREREQUISITES"
LIMIT=80

cat "$PREREQ/template.md" > "$PREREQ/README.md"
for x in "$PARENT/tools/.prerequisites/"*; do
	sort -u -o "$x" "$x"
	vals="\\\\\n "
	c=0
	for v in $(sed 's/[\t ]*#.*//g' "$x" | sort | tr '\n' ' '); do
		c=$(( ${c} + ${#v} ))
		[ $c -gt $LIMIT ] && c=0 && vals="$vals \\\\\n "
		vals="$vals $v"
	done
	sed -i "s!%%${x##*/}%%!${vals% }!" "$PREREQ/README.md"
done

