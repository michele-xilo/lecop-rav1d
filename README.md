# lecop-rav1d

A fork of [rusty_av1d](https://github.com/Remade-With-Rust/rusty-av1-toolkit) 1.3.0 (itself a fork of
[rav1d](https://github.com/memorysafety/rav1d)) for [leCop](https://github.com/michele-xilo/leCop), with one change:
the x86_64 assembly ships already assembled in `prebuilt/`, so building the crate with its assembly needs no
[nasm](https://nasm.us/) on Linux, Windows or macOS. ARM builds are unchanged (the C compiler assembles them).

- `prebuilt/assemble.sh` makes the objects from `src/x86/*.asm` with nasm 3.01. CI assembles them again with that
  nasm and fails if a single byte differs from what is checked in.
- `RAV1D_NASM=1` makes the build assemble from source with your nasm instead, as upstream does.
- After changing anything under `src/x86` or `src/ext/x86`, run `prebuilt/assemble.sh` and commit the result.

The upstream README follows.

