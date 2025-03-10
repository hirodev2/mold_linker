#!/bin/bash
. $(dirname $0)/common.inc

cat <<'EOF' > $t/a.ver
{
  global: *;
  local: foo;
};
EOF

cat <<EOF | $CXX -fPIC -c -o $t/b.o -xc -
void foobar() {}
void foo() {}
EOF

$CC -B. -shared -Wl,--version-script=$t/a.ver -o $t/c.so $t/b.o

readelf --dyn-syms $t/c.so > $t/log
grep ' foobar' $t/log
not grep ' foo$' $t/log
