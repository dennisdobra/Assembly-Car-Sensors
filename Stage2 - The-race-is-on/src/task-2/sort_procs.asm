%include "../include/io.mac"

struc proc
    .pid: resw 1 ; 2 bytes = half a register
    .prio: resb 1 ; 1 byte = a quarter of a register
    .time: resw 1 ; 2 bytes = half a register
endstruc

section .text
    global sort_procs
	extern printf
sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
	mov esi, edx			; point to the vector in esi
	xor ecx, ecx            ; ecx is the outer loop counter: i = 0

    outer_loop:
		sub eax, 1
        cmp ecx, eax        ; if ecx == length - 1
        je done

		add eax, 1

        xor edi, edi         ; edx is the inner loop counter: j = 0
        mov edi, ecx        ; edi == i
		add edi, 1			; j = i + 1
        inner_loop:
            cmp edi, eax ; if j == n
            je next_iteration

			push eax
			push edi
			push ecx

			imul edi, edi, 5 ; traverse in steps of 5
			imul ecx, ecx, 5

			compare_prio:
				xor eax, eax
				xor edx, edx
				mov al, [esi + edi + proc.prio]
				mov dl, [esi + ecx + proc.prio]
				cmp al, dl
				jl swap_prio	; sort in ascending order

				cmp al, dl
				je compare_time ; compare by time if priorities are equal

				cmp al, dl
				jg continue
			compare_time:
				xor eax, eax
				xor edx, edx
				mov ax, [esi + edi + proc.time]
				mov dx, [esi + ecx + proc.time]
				cmp ax, dx
				jl swap_time

				cmp ax, dx
				je compare_pid

				cmp ax, dx
				jg continue
			compare_pid:
				xor eax, eax
				xor edx, edx
				mov ax, [esi + edi + proc.pid]
				mov dx, [esi + ecx + proc.pid]
				cmp ax, dx
				jl swap_pid

				cmp ax, dx
				jge continue

			swap_prio:
				push eax
				push edx
				pop eax
				pop edx
				mov [esi + edi + proc.prio], al
				mov [esi + ecx + proc.prio], dl
			
			swap_time:
				xor eax, eax
				xor edx, edx
				mov ax, [esi + edi + proc.time]
				mov dx, [esi + ecx + proc.time]

				push eax
				push edx
				pop eax
				pop edx
				mov [esi + edi + proc.time], ax
				mov [esi + ecx + proc.time], dx

			swap_pid:
				xor eax, eax
				xor edx, edx
				mov ax, [esi + edi + proc.pid]
				mov dx, [esi + ecx + proc.pid]
				
				push eax
				push edx
				pop eax
				pop edx
				mov [esi + edi + proc.pid], ax
				mov [esi + ecx + proc.pid], dx

			continue:
				pop ecx
				pop edi
				pop eax
				inc edi
				jmp inner_loop

			next_iteration:
				inc ecx	; increment the inner loop counter
				jmp outer_loop
    done:
	;; Your code ends here
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
