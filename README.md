# x86-yureios

A simple 16-bit OS for x86, built with `fasm`.

## Build

```bash
fasm boot.asm boot.bin
fasm print.asm print.bin
cat boot.bin print.bin > yureios.bin
```

## Run

```bash
qemu-system-x86_64 -drive format=raw,file=yureios.bin -nographic
```

## Tools

  - [fasm](https://flatassembler.net/)
  - [QEMU emulatorx86](https://www.qemu.org/)


## Core Functions

A brief overview of the key kernel functions:

### `welcome`

Displays the initial welcome message: `YureiOS v0.1 initialized.` [cite: print.asm]

### `type_char`

The main OS loop. Waits for a key press (`int 16h`) [cite: projectyurei/x86-yureios/print.asm]. It echoes the character to the screen and calls `backspace` or `handle_enter` when needed.

### `handle_enter`

Called when `Enter` is pressed. It compares the input `buffer` [cite: print.asm] against known commands (`ver`, `clear`) [cite: print.asm] and jumps to the correct function or `cmd_fail`.

### `print_string`

A utility to print a null-terminated string to the screen. It stops when it finds a `0` byte.

### `backspace`

Handles the backspace key press. It moves the cursor back, prints a space to erase the character, and moves the cursor back again.

### `clear_screen`

Clears the entire screen and calls `welcome` [cite: print.tmp.asm] again.
