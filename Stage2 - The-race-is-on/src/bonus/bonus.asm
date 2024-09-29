%include "../include/io.mac"
section .data

section .text
    global bonus
    extern printf
function:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8]
    
    ; Check to see which part of the table we are in -> upper or lower
    cmp edx, 31
    jle lower

    cmp edx, 31
    jg upper
    
lower:
    add ecx, 4
    mov edi, 1
    loop1:
        cmp edx, 0
        je continue1
        imul edi, edi, 2
        sub edx, 1
        jmp loop1
    continue1:
        add [ecx], edi
        sub ecx, 4    ; Return to the initial position

    jmp finish

upper:
    sub edx, 32
    mov edi, 1
    loop2:
        cmp edx, 0
        je continue2
        imul edi, edi, 2
        sub edx, 1
        jmp loop2
    continue2:
        add [ecx], edi
        
    jmp finish    

finish:
    leave
    ret

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]   ; x
    mov ebx, [ebp + 12]  ; y
    mov ecx, [ebp + 16]  ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
    push ecx ; Retain value from ecx
    push eax ; Make a copy of eax
    push ebx 

    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    sub edx, 1    ; Subtract 1 from the row index to go up
    inc edi       ; Add 1 to the column index to go right

    cmp edx, 0    ; Check if we are at the upper edge
    jl right_lower ; If we are at the upper edge, skip setting the element
    cmp edi, 7    ; Check if we are at the right edge
    jg right_lower ; If we are at the right edge, skip setting the element

    mov eax, edx  ; Copy the row index into eax for indexing
    mov ebx, edi  ; Copy the column index into ebx for indexing
    imul eax, 8
    add eax, ebx

    ; Call the function
    push eax
    call function
    add esp, dword 4

right_lower:
    ; Set the elements in the lower-left and lower-right to 1 if possible
    pop ebx
    pop eax
    pop ecx ; Restore value from ecx

    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    push ecx ; Retain value from ecx
    push eax  ; Make a copy of eax
    push ebx

    inc edx     ; Add 1 to the row index to go down
    inc edi     ; Add 1 to the column index to go right

    cmp edx, 7  ; Check if we are at the lower edge
    jg left_up  ; If we are at the lower edge, finish
    cmp edi, 7  ; Check if we are at the right edge
    jg left_up  ; If we are at the right edge, finish

    mov eax, edx  ; Copy the row index into eax for indexing
    mov ebx, edi  ; Copy the column index into ebx for indexing

    imul eax, 8
    add eax, ebx

    push eax
    call function
    add esp, dword 4

left_up:
    pop ebx
    pop eax
    pop ecx ; Restore value from ecx
    
    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    push ecx ; Retain value from ecx
    push eax  ; Make a copy of eax
    push ebx

    sub edx, 1  ; Subtract 1 from the row index to go up
    sub edi, 1  ;

    cmp edx, 0  ; Check if we are at the lower edge
    jl left_lower ; If we are at the lower edge, finish
    cmp edi, 0  ; Check if we are at the right edge
    jl left_lower ; If we are at the right edge, finish
    mov eax, edx  ; Copy the row index into eax for indexing
    mov ebx, edi  ; Copy the column index into ebx for indexing
    imul eax, 8
    add eax, ebx

    push eax
    call function
    add esp, dword 4

left_lower:
    pop ebx
    pop eax
    pop ecx ; Restore value from ecx
    
    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    add edx, 1   ; Add 1 to the row index to go up
    sub edi, 1   ;
    
    cmp edx, 7   ; Check if we are at the lower edge
    jg done      ; If we are at the lower edge, finish
    cmp edi, 0   ; Check if we are at the right edge
    jl done      ; If we are at the right edge, finish
    mov eax, edx  ; Copy the row index into eax for indexing
    mov ebx, edi  ; Copy the column index into ebx for indexing
    imul eax, 8
    add eax, ebx

    push eax
    call function
    add esp, dword 4
done:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
