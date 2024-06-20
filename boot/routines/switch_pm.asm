[bits 16]
switch_to_pm:
    cli                   ; disable bios interrupts
    lgdt [gdt_descriptor] ; set up the gdt table by loading the gdt descriptor
    mov eax, cr0           
    or eax, 0x1           ; set the first bit of cr0 flags to 1, indicating 32 bit mode 
    mov cr0, eax          ; using or to preserve other flags
    jmp CODE_SEG:init_pm  ; far jump to code segment, as described in GDT
                          ; far jump is needed to force the CPU to flush its cache of
                          ; pre - fetched and real - mode decoded instructions
                          

[bits 32]            ; directing assembler to use 32bit mode
init_pm: 
    mov ax, DATA_SEG ; pointing all segments to the data segment of our GDT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; updating the stack at the top of the free space
    mov esp, ebp

    call BEGIN_PM    ; Jumping to the post PM label
