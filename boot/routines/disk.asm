; dh - numbers of sectors to load
; dl - drive number to load from
; es:bx - address to memory where the read data is loaded
disk_load: ; using interrupt 0x13 of BIOS, using CHS addressing 
    pusha
    push dx ; dh contains numbers of secrtors instructed to load, saving it for later use

    ; parameters required by interrupt 0x13:
    mov ah, 0x02 ; read mode for interrup 0x13
    mov al, dh   ; numbers of sectors to read
    mov cl, 0x02 ; the sector to read, indexing start from 1 (0x01 is the boot sector)
    mov ch, 0x00 ; cylinder number
    mov dh, 0x00 ; head number
    ; dl - disk number to load from, set up as a parameter by caller
    ; [es:bx] - pointer to buffer where the data will be stored, set up by caller

    int 0x13      ; BIOS interrupt
    jc disk_error ; if carry bit is set (i.e. disk reading error occured)

    pop dx        ; dh - numbers of sectors to load
    cmp al, dh    ; al - numbers of sectors actually loaded, set up by bios
    jne sectors_error   ; not all sectors are read, if not equal
    popa
    ret


disk_error:
    mov bx, DISK_ERROR
    call print_string
    call endl
    jmp $

sectors_error:
    mov bx, SECTORS_ERROR
    call print_string
    jmp $

jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
