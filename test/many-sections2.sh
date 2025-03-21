#!/bin/bash
. $(dirname $0)/common.inc

# OneTBB isn't tsan-clean
nm mold | grep '__tsan_init' && skip

echo 'foo = 0x1000' > $t/a.s
seq 1 100000 | sed 's/.*/.section .data.&,"aw"\n.globl x&\nx&: .word 0\n/g' >> $t/a.s
$CC -c -xassembler -o $t/a.o $t/a.s

./mold --relocatable -o $t/b.o $t/a.o

readelf -WS $t/b.o > $t/log1
grep -F .data.100000 $t/log1

readelf -Ws $t/b.o > $t/log2
grep -F 'GLOBAL DEFAULT 100000' $t/log2
grep -F 'ABS foo' $t/log2
not grep -F 'ABS x68966' $t/log2
