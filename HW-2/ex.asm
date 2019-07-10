extern printf

section.data
prompt_hex: db '0x%08x', 10, 00
prompt_int: db '%d', 10, 00
prompt_str: db '%s', 10, 00 
 
section.text
global main 
main:
    push ebp
    mov ebp, esp
 
    mov eax, [ebp+12]
    lea eax, [eax+4]
    push eax 
    push prompt_hex
    call printf
    add esp, 8
    
    mov eax, [ebp+12]
    lea eax, [eax+4]
    push dword[eax]
    push prompt_str
    call printf
    add esp, 8

    leave
    ret
