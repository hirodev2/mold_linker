#!/bin/bash
. $(dirname $0)/common.inc

[[ $MACHINE = riscv* ]] && skip
[[ $MACHINE = loongarch* ]] && skip

cat <<EOF | $CC -o $t/a.o -c -x assembler -Wa,-L -
  .text
  .globl _start
_start:
  nop
foo:
  nop
.Lbar:
  nop
EOF

./mold -o $t/exe $t/a.o
readelf --symbols $t/exe > $t/log
grep -Fq _start $t/log
grep -Fq foo $t/log
grep -Fq .Lbar $t/log

./mold -o $t/exe $t/a.o --discard-locals
readelf --symbols $t/exe > $t/log
grep -Fq _start $t/log
grep -Fq foo $t/log
not grep -Fq .Lbar $t/log

./mold -o $t/exe $t/a.o --discard-all
readelf --symbols $t/exe > $t/log
grep -Fq _start $t/log
not grep -Fq foo $t/log
not grep -Fq .Lbar $t/log

./mold -o $t/exe $t/a.o --strip-all
readelf --symbols $t/exe > $t/log
not grep -Fq _start $t/log
not grep -Fq foo $t/log
not grep -Fq .Lbar $t/log
