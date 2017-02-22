bits 64

call geteip
 db "[written by shellcode]", 0x0a, 0

geteip:
  pop rcx

mov rax, 4  ; sys_write
mov rbx, 1  ; stdout
mov rdx, 24 ; length
sysenter
