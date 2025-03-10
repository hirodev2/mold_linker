#!/bin/bash
. $(dirname $0)/common.inc

cat <<EOF | $CC -o $t/a.o -c -xc -
int foo = 5;
void bar() {}
int main() {}
EOF

$CC -B. -o $t/exe $t/a.o -Wl,-dynamic-list-data
readelf -W --dyn-syms $t/exe > $t/log
grep -w foo $t/log
not grep -w bar $t/log
