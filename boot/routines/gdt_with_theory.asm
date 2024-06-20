; A basic Flat Memory Mmodel GDT

gdt_start: 
    ; declaring the null segmet of 8 bytes, to catch any refrencing errors
    dd 0
    dd 0

; ---------------- Theory -----------------------
; Base       - 32 bit - describes the starting location of the segment
; Limit      - 20 bit - describes the size of the segment
; Flags - boolean values for setting permissions and descriptions
;   1st flag    - 4 bit:
;       Present    - 1 bit - 1 if the segment will be used otherwise 0 (mostly set to 1)
;       Privilege  - 2 bit - to declare a segment heirarchy, implmenting memory protection (00>01>10>11, 00 "ring" being most privileged)
;       Desc. Type - 1 bit - 1 for code/data segments, 0 is used for traps
;   Type Flag   - 4 bit - based on the segment, written below
;   Other Flags - 4 bit -
;       Granularity    - If set, we can span 4GB of memory (by multiplying limit by 0x1000)
;       32-bit default - If set, CPU uses 32 bit memory istead of 16 bit
;       64-bit code    - 0, unused on 32 bit processor
;       AVL            - available flag, for debug/testing

; NOTE: the base and limit bits are scattered accros the descriptor segment, making it even more confusing
; (is this a joke?)

; -------------- Code Segment -------------------
; GDT for code segment. 

; Flags:
;   Type Flag - 4 bit - as follows:
;       Code       - 1 for Code, 0 for Data
;       Conforming - whether the lower privleged segment access this segment? 0 for no, 1 for yes. Memory protection. 
;       Readable   - Is this segment readable? 1 for readable, 0 for executable only. (readable allows us to read constants)
;       Accessed   - Accessed by the CPU? set to 0, will be set automatically by CPU, used for debugging or others.
; base = 0x00000000, limit = 0xfffff
; 1st Flags  - 1001
; Type Flags - 1010
; Other Flag - 1100



gdt_code: 
    dw 0xffff    ; define first 16 bits of the segment limit (bits 0-15)
    
    dw 0       ; define first 16 bits of the segment base (bits 0-15)
    db 0       ; define later 8 bits of the segment base (bits 16-23)  
    ; i.e. defining first 24 bits of the base
    db 10011010b ; 1st Flags + Type Flags
    db 11001111b ; Other Flags + remaining bits of segment limit, bits 16-19
    db 0       ; remaining bits of segment base, (bits 24-31)

; this is a joke

; -------------- Data Segment -------------------
; GDT for Data segment. 

; Flags:
;   Type Flag - 4 bit - as follows:
;       Code       - 1 for Code, 0 for Data
;       Direction  - 1 for expanding down (like a stack), else 0
;       Writable   - Is this segment writable? 1 for writable, 0 for read only.
;       Accessed   - Accessed by the CPU? set to 0, will be set automatically by CPU, used for debugging or others.
; base = 0x00000000, limit = 0xfffff
; 1st Flags  - 1001
; Type Flags - 0010
; Other Flag - 1100
gdt_data:
    dw 0xffff
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; size of GDT (16 bit), always one less of its true size
    dd gdt_start                ; address (32 bit)

; define some constants for later use, in kernel loading and switching to pm
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
