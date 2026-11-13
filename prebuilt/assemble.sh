#!/bin/bash
# Assemble the x86_64 sources into <out>/<format>/*.o, with the config build.rs writes for a release build.
# --reproducible keeps the build time out of the COFF headers, so the same source always gives the same bytes.
# usage: prebuilt/assemble.sh [out-dir]   (default: prebuilt). CI runs it into a temp dir and compares with prebuilt/.
set -euo pipefail
cd "$(dirname "$0")/.."
out=${1:-prebuilt}
cfg=$(mktemp -d)
for fmt in elf64 win64 macho64; do
  {
    echo '%define CONFIG_ASM 1'
    echo '%define CONFIG_LOG 1'
    [ $fmt = macho64 ] && echo '%define PREFIX 1'
    echo '%define private_prefix dav1d'
    echo '%define ARCH_X86_32 0'
    echo '%define ARCH_X86_64 1'
    echo '%define STACK_ALIGNMENT 16'
    echo '%define PIC 1'
    echo '%define FORCE_VEX_ENCODING 0'
  } > "$cfg/config.asm"
  mkdir -p "$out/$fmt"
  for f in src/x86/*.asm; do
    b=$(basename "$f" .asm)
    case $b in x86inc|filmgrain_common|cpuid) continue ;; esac
    nasm --reproducible -f $fmt -I"$cfg/" -Isrc/ -o "$out/$fmt/$b.o" "$f"
  done
done
