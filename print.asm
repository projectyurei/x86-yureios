org 0x8000

mov dx, 0 
mov bx, 0 
mov cx, 0 
mov ax, 0
mov di, 0
    
call clear_screen

start_os:
    call clean_buffer
    mov dx, 0 
    mov bx, 0 
    mov cx, 0 
    mov ax, 0
    mov di, 0
    mov [buf_pos], ax
    jmp type_char

print_string:
    push ax
    push si
    .str_loop:
        lodsb
        cmp al, 0
        je .str_done
        mov ah, 0x0e
        int 10h 
        jmp .str_loop
    .str_done:
    pop si
    pop ax
    ret

type_char:
    xor ah, ah
    int 16h 

    cmp ah, 0x0e ; Backspace
    je  backspace

    cmp ah, 0x1c ; Enter
    je  handle_enter

    mov di, buffer
    mov bx, [buf_pos]
    add di, bx
    mov [di], al
    inc bx
    mov [buf_pos], bx

    mov ah, 0x0e
    int 10h
    jmp type_char

backspace:
    mov ah, 0x03
    int 10h 

    mov ah, 0x02
    mov bh, 0
    dec dl
    int 0x10

    mov ah, 0x0e
    mov al, ' ' 
    int 0x10

    mov ah, 0x02
    mov bh, 0
    int 0x10

    jmp type_char 

set_cursor_top_left:
    mov ah, 02h 
    mov dh, 0 
    mov dl, 0
    int 10h
    ret

clean_buffer:
    push di 
    mov di, buffer
    xor cx, cx
    mov cx, 80 
    rep stosd 
    pop di 
    ret
    
welcome:
    mov si, welcome_message
    call print_string
    call newline
    jmp start_os 

clear_screen:
    call set_cursor_top_left
    mov dx, 0 
    mov bx, 0 
    mov cx, 0 
    mov ax, 0
    mov di, 0
    mov ah, 09h
    mov al, ' '
    mov bl, 7 ; BLACK on BLACK (default)
    mov cx, 80 * 25 
    int 10h 
    call set_cursor_top_left
    call welcome

handle_enter:
    mov di, buffer
    mov bx, [buf_pos]
    add di, bx
    mov byte [di], 0

    ; Check for 'ver' command
    mov si, buffer
    mov di, cmd_ver
    mov cx, 3 ; 'ver' is 3 chars
    repe cmpsb
    jz cmd_ok

    ; Check for 'clear' command
    mov si, buffer
    mov di, cmd_cls
    mov cx, 5 ; 'clear' is 5 chars (FIXED from 6)
    repe cmpsb
    jz clear_screen

cmd_fail:
    call newline
    mov si, fail_msg
    call print_string
    call newline
    call clean_buffer
    xor ax, ax
    mov [buf_pos], ax
    jmp type_char

cmd_ok:
    ; This is for 'ver' command
    call newline
    mov si, ok_msg
    call print_string
    call newline
    call clean_buffer
    xor ax, ax
    mov [buf_pos], ax
    jmp type_char

newline:
    mov ah, 0x03
    int 10h
    mov ah, 02h 
    inc dh 
    mov dl, 0
    int 10h
    ret

; data -------------------------------

welcome_message  db 'YureiOS v0.1 initialized.', 0x0A, 0x0D, 'Type ''ver'' or ''clear''.$', 0

ok_msg           db 'YureiOS Version 0.1$', 0
fail_msg         db 'Command not found.$', 0

cmd_ver db 'ver',0
cmd_cls db 'clear',0

buffer    db 80 dup (0)
buf_pos   dw 0   

times 512 - ( $ - $$ ) db 0
