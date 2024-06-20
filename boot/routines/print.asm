print_string:
    ; parameter - bx
    ; bx - pointing to the start of the string to print
    ;
    pusha   ; saving all registers on start

loop_start:
    mov al, [bx] ; 'al' is the parameter to be printed, for interrupt 0x10

    cmp al, 0    ; comparing if string is ended (as strings are null terminated)
    je end      ; if terminated, jump to end

    mov ah, 0x0e ; parameter required by interrup 0x10 to enter TTY mode
    int 0x10 

    add bx, 1    ; go to next character of the string
    jmp loop_start

end:
    popa    ; restoring the registers from stack
    ret     ; return to the caller


endl:   ; to go to a new line
    
    pusha   ; saving all registers on start
    
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    
    popa    ; restoring the registers from stack
    ret

clr:
    pusha

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    popa
    ret