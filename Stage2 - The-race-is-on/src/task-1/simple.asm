%include "../include/io.mac"

section .text
    global simple ; the "simple" function can be called from other parts of the program
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp; save the base pointer of the stack
    mov     ebp, esp; move esp into ebp
    pusha; save all general-purpose registers onto the stack

	; general-purpose registers
    mov     ecx, [ebp + 8]  ; len   // move the value of parameter "len" (the length of the plaintext) into register ECX
    mov     esi, [ebp + 12] ; plain // move the value of parameter "plain" (the plaintext) into register ESI
    mov     edi, [ebp + 16] ; enc_string // move the value of parameter "enc_string" (the encrypted text) into register EDI
    mov     edx, [ebp + 20] ; step  // move the value of parameter "step" (the number of positions to shift) into register EDX

    ;; DO NOT MODIFY
   
    ;; Your code starts here
	mov ebx, 0           ; loop counter

	loop_start:
		cmp     ebx, ecx    ; check if we have reached the end of the string
		jge     loop_end    ; if yes, exit the loop (jump if greater than or equal)

		mov eax, 0			; initialize eax with 0
		mov     al, [esi + ebx]   ; move the current character from plain into al

		add     eax, edx            ; add the shift value to the index in the alphabet
		
		cmp     eax, 'Z'			; check if the resulting value exceeds the value of letter Z
		jle     skip_shift				; if not, move to the next character
		sub     eax, 26             ; if yes, subtract 26 to wrap around to the start of the alphabet

	skip_shift:
		mov     [edi + ebx], eax   ; put the shifted character in the encrypted text
		inc     ebx            ; increment the loop counter
		jmp     loop_start     ; move to the next character

	loop_end:
	;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
