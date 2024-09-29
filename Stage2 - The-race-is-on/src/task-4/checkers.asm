section .data

section .text
    global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x - the row where the piece is located
    mov ebx, [ebp + 12]	; y - the column where the piece is located
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE
    push ecx ; save the value from ecx
    push eax ; make a copy of eax
    push ebx ; save the value from ebx

    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    sub edx, 1  ; Decrement the row index to move up
    inc edi  	; Increment the column index to move right

    cmp edx, 0  	; Check if we are at the top edge
    jl dreapta_jos  ; If we are at the top edge, skip setting the element
    cmp edi, 7  	; Check if we are at the right edge
    jg dreapta_jos  ; If we are at the right edge, skip setting the element

    mov eax, edx  	; Copy the row index into eax for indexing
    mov ebx, edi  	; Copy the column index into ebx for indexing
    imul eax, 8
    add ecx, eax
    add ecx, ebx
    mov [ecx], byte 1  	; Set the top right corner to 1 

dreapta_jos:
    pop ebx
    pop eax
    pop ecx ; restore the value to ecx

    mov edx, eax  ; Copy the row index into edx
    mov edi, ebx  ; Copy the column index into edi

    push ecx 		; save the value from ecx
    push eax 		; make a copy of eax
    push ebx

    inc edx  		; Increment the row index to move down
    inc edi  		; Increment the column index to move right

    cmp edx, 7  	; Check if we are at the bottom edge
    jg stanga_sus  	; If we are at the bottom edge, finish
    cmp edi, 7  	; Check if we are at the right edge
    jg stanga_sus  	; If we are at the right edge, finish

    mov eax, edx  	; Copy the row index into eax for indexing
    mov ebx, edi  	; Copy the column index into ebx for indexing

    imul eax, 8
    add ecx, eax
    add ecx, ebx
    mov [ecx], byte 1  ; Set the bottom right corner to 1

stanga_sus:

    pop ebx
    pop eax
    pop ecx 		; restore the value to ecx
	
    mov edx, eax  	; Copy the row index into edx
    mov edi, ebx  	; Copy the column index into edi

    push ecx 		; save the value from ecx
    push eax 		; make a copy of eax
    push ebx

    sub edx, 1  	; Decrement the row index to move up
    sub edi, 1  

    cmp edx, 0  	; Check if we are at the top edge
    jl stanga_jos 	; If we are at the top edge, finish
    cmp edi, 0  	; Check if we are at the left edge
    jl stanga_jos 	; If we are at the left edge, finish
    mov eax, edx  	; Copy the row index into eax for indexing
    mov ebx, edi  	; Copy the column index into ebx for indexing
    imul eax, 8
    add ecx, eax
    add ecx, ebx
    mov [ecx], byte 1  ; Set the bottom left corner to 1

stanga_jos:
    pop ebx
    pop eax
    pop ecx 		; restore the value to ecx
	
    mov edx, eax  	; Copy the row index into edx
    mov edi, ebx  	; Copy the column index into edi

    add edx, 1  	; Increment the row index to move down
    sub edi, 1  
	
    cmp edx, 7  	; Check if we are at the bottom edge
    jg done  		; If we are at the bottom edge, finish
    cmp edi, 0  	; Check if we are at the left edge
    jl done  		; If we are at the left edge, finish
    mov eax, edx  	; Copy the row index into eax for indexing
    mov ebx, edi  	; Copy the column index into ebx for indexing
    imul eax, 8
    add ecx, eax
    add ecx, ebx
    mov [ecx], byte 1  ; Set the top left corner to 1
done:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
