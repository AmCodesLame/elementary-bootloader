[org 0x7c00]                ; setting the origin where the BIOS will load this secter
KERNEL_OFFSET equ 0x1000    ; will load kernel here, same offset is expected by the linker while linking kernel files (using -Ttext 0x1000 flag)

mov [BOOT_DRIVE], dl    ; saving the boot drive (BIOS loads 'dl' register with the boot drive number)
mov bp, 0x9000          ; setting up the stack base, far from our code to avoid overwriting
mov sp, bp              ; setting up the stack top    

mov bx, MSG_REAL_MODE   ; printing that we entered real mode
call print_string              
call endl   

call load_kernel        ; load kernel from the disk

call clr

call switch_to_pm       ; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
jmp $                   ; Never executed

%include "boot/routines/print.asm"
%include "boot/routines/disk.asm"
%include "boot/routines/gdt.asm"
%include "boot/routines/switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string
    call endl

    mov bx, KERNEL_OFFSET   ; destination of our disk_load call (i.e. where the kernel will laod)
    mov dh, 16              ; number of sectors to read
    mov dl, [BOOT_DRIVE]    ; the disk number to read from (which is the same disk as boot sector's)
    call disk_load
    ret

[bits 32]
BEGIN_PM:


    call KERNEL_OFFSET  ; Give control to the kernel
    jmp $               ; in case the kernel returns, loops infinitely 


BOOT_DRIVE db 0 
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

times 510 - ($-$$) db 0 ; padding
dw 0xaa55               ; magic numbers
