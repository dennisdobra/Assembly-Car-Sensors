%include "../include/io.mac"

struc avg
	.quo: resw 1
	.remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0	; number of processes
    time_result dd 0, 0, 0, 0, 0	; sum for each priority

section .text
    global run_procs
	extern printf
run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here
	xor edx, edx			; index for priorities: 1, 2, 3, 4, 5
	mov esi, ecx			; point to the array in esi

	priority_loop:
		cmp edx, 0
		jg division
		
		jmp jump
		division:
			push eax
			push ecx
			push edx
			push esi
			push ebx
			xor esi, esi
			mov esi, eax
			mov ecx, edx	; move edx to ecx to keep edx free for division

			mov eax, [time_result + 4 * (ecx - 1)]    ; current value from time_result
        	mov ebx, [prio_result + 4 * (ecx - 1)]    ; current value from prio_result

			cmp ebx, 0      ; check if the divisor is zero
        	jz divisor_zero

        	xor edx, edx    ; reset edx to zero
        	div ebx         ; divide eax / ebx
			mov [esi + 4 * (ecx - 1) + avg.quo], ax   ; quotient of the division becomes .quo in the avg structure

			mov eax, edx    ; remainder of the division becomes eax for display
        	mov [esi + 4 * (ecx - 1) + avg.remain], dx  ; remainder of the division becomes .remain in the avg structure


        	jmp continue_division

    		divisor_zero:
        	mov [esi + 4 * (ecx - 1) + avg.quo], word 0
			mov [esi + 4 * (ecx - 1) + avg.remain], word 0
			continue_division:
			pop ebx
			pop esi
			pop edx
			pop ecx
			pop eax
		jump:
		add edx, 1			; move to the next priority
		cmp edx, 5		
		jg done				; means we have gone through the vector 5 times

		xor ecx, ecx            ; ecx is the array_loop counter: i = 0

		xor edi, edi 			; in edi I will calculate the sum of time quotients
		array_loop:
			cmp ecx, ebx		; ebx == length
			jge priority_loop	; means we have traversed the vector and move to the next priority
			push eax
			push ecx
			imul ecx, ecx, 5
			mov al, [esi + ecx + proc.prio]	; load into dl, the priority of each element from the array
			cmp al, dl ; compare priorities
			je sum_time

			pop ecx

			cmp al, dl
			jg next_iteration	; if the priority does not match the current priority, move to the next element in the array

			cmp al, dl
			jl next_iteration	

			sum_time:
				sub edx, 1 ; one less than the priority to navigate through the array
				mov di, [time_result + 4 * edx] ; sum up to this moment
				add di, [esi + ecx + proc.time] ; add the time quotient to edi
				mov [time_result + 4 * edx], di ; store the sum 
				mov al, [prio_result + 4 * edx] ; increment the number of priorities
				add al, 1; add 1 to the number of priorities
				mov [prio_result + 4 * edx], al
				add edx, 1

				pop ecx
		next_iteration:
			pop eax
			inc ecx	; increment the array_loop counter
			jmp array_loop
			
	done:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
