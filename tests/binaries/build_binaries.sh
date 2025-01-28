#!/bin/bash

# print commands
set -x

mkdir -p output

# All hardening features on (except for CFI and SafeStack)
gcc -o output/all test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
# All hardening features on and static pie
gcc -o output/all_static test.c -w -static-pie -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -s
# All hardening features on and strip section headers (check fortify and ssp)
strip --strip-section-headers -o output/all_strip output/all
# Partial RELRO
gcc -o output/partial test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z lazy -z noexecstack -s
# no RELRO and bind now
gcc -o output/now test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z norelro -z now -z noexecstack -s
# RPATH
gcc -o output/rpath test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--disable-new-dtags
# RUNPATH
gcc -o output/runpath test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--enable-new-dtags
# no hardening features
gcc -o output/none test.c -w -D_FORTIFY_SOURCE=0 -fno-stack-protector -no-pie -O2 -z norelro -z lazy -z execstack
# no hardening features and strip section headers
strip --strip-section-headers -o output/none_strip output/none
# no hardening features and static (fortify n/a all)
gcc -o output/none_static test.c -w -static -D_FORTIFY_SOURCE=0 -fno-stack-protector -no-pie -O2 -z norelro -z lazy -z execstack
# REL (PIE)
gcc -c test.c -o output/rel.o
# DSO (PIE)
gcc -shared -fPIC -o output/dso.so test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -O2 -z relro -z now -z noexecstack -s
# CFI and SafeStack
clang -o output/cfi test.c -w -flto -fsanitize=cfi -fvisibility=default
clang -o output/sstack test.c -w -fsanitize=safe-stack
strip --strip-section-headers -o output/cfi_strip output/cfi
strip --strip-section-headers -o output/sstack_strip output/sstack
# clang instead of gcc
clang -o output/all_cl test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
strip --strip-section-headers -o output/all_strip_cl output/all_cl
clang -o output/partial_cl test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z lazy -z noexecstack -s
clang -o output/now_cl test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z norelro -z now -z noexecstack -s
clang -o output/rpath_cl test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--disable-new-dtags
clang -o output/runpath_cl test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--enable-new-dtags
clang -o output/none_cl test.c -w -D_FORTIFY_SOURCE=0 -fno-stack-protector -no-pie -O2 -z norelro -z lazy -z execstack
strip --strip-section-headers -o output/none_strip_cl output/none_cl
clang -c test.c -o output/rel_cl.o
clang -shared -fPIC -o output/dso_cl.so test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -O2 -z relro -z now -z noexecstack -s

# 32-bit (use gcc-multilib)
gcc -m32 -o output/all32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
strip --strip-section-headers -o output/all_strip32 output/all32
gcc -m32 -o output/partial32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z lazy -z noexecstack -s
gcc -m32 -o output/now32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z norelro -z now -z noexecstack -s
gcc -m32 -o output/rpath32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--disable-new-dtags
gcc -m32 -o output/runpath32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--enable-new-dtags
gcc -m32 -o output/none32 test.c -w -D_FORTIFY_SOURCE=0 -fno-stack-protector -no-pie -O2 -z norelro -z lazy -z execstack
strip --strip-section-headers -o output/none_strip32 output/none32
gcc -m32 -c test.c -o output/rel32.o
gcc -m32 -shared -fPIC -o output/dso32.so test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -O2 -z relro -z now -z noexecstack -s

clang -m32 -o output/cfi32 test.c -w -flto -fsanitize=cfi -fvisibility=default
clang -m32 -o output/sstack32 test.c -w -fsanitize=safe-stack
strip --strip-section-headers -o output/cfi_strip32 output/cfi32
strip --strip-section-headers -o output/sstack_strip32 output/sstack32
clang -m32 -o output/all_cl32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
strip --strip-section-headers -o output/all_strip_cl32 output/all_cl32
clang -m32 -o output/partial_cl32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z lazy -z noexecstack -s
clang -m32 -o output/now_cl32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z norelro -z now -z noexecstack -s
clang -m32 -o output/rpath_cl32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--disable-new-dtags
clang -m32 -o output/runpath_cl32 test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s -Wl,-rpath,./ -Wl,--enable-new-dtags
clang -m32 -o output/none_cl32 test.c -w -D_FORTIFY_SOURCE=0 -fno-stack-protector -no-pie -O2 -z norelro -z lazy -z execstack
strip --strip-section-headers -o output/none_strip_cl32 output/none_cl32
clang -m32 -c test.c -o output/rel_cl32.o
clang -m32 -shared -fPIC -o output/dso_cl32.so test.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -O2 -z relro -z now -z noexecstack -s

# Fortify source (nothing fortifiable)
gcc -o output/fs0 nothing.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
clang -o output/fs0_cl nothing.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
gcc -m32 -o output/fs032 nothing.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
clang -m32 -o output/fs0_cl32 nothing.c -w -D_FORTIFY_SOURCE=3 -fstack-protector-strong -fpie -O2 -z relro -z now -z noexecstack -pie -s
strip --strip-section-headers -o output/fs0_strip output/fs0
strip --strip-section-headers -o output/fs0_strip_cl output/fs0_cl
strip --strip-section-headers -o output/fs0_strip32 output/fs032
strip --strip-section-headers -o output/fs0_strip_cl32 output/fs0_cl32