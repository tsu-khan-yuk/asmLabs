;; main.asm
; https://prog-cpp.ru/asm-segment/
STACK_SEG 	SEGMENT PARA STACK "STACK"
					db  8 dup ("STACK")
STACK_SEG 	ENDS

DATA_SEG 	SEGMENT PARA PUBLIC "DATA"
	hello_string 	db 	14, "Input number: "
	input_digit		db 	5, ?, 5 dup("?")
	error_msg 		db 	12, "Invalid data"
DATA_SEG 	ENDS


CODE_SEG 	SEGMENT PARA PUBLIC "CODE"

	ASSUME 	CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

	OUTPUT_PROC		PROC NEAR

		mov 	ah, 02h
		printing: 
			mov 	dl, [di]
			int 	21h
			inc 	di
		loop 	printing

		ret		
	OUTPUT_PROC 		ENDP


	INPUT_VALUE 	PROC NEA

		mov 	ah, 10
		int 	21h

		mov	 	dl,0ah
	    mov 	ah,02
	    int 	21h 

		ret
	INPUT_VALUE 	ENDP


	STR_TO_INT 		PROC NEAR

		cmp 	byte ptr [di], '-'
		jne		short positiv_num
			mov 	si, 1
			inc 	di
		positiv_num:
		xor 	ax, ax
		mov 	bx, 10
		main_array_cycle:

			mov 	cl, [di]
			cmp 	cl, 0Dh
			je 		short end_line

			cmp 	cl, '0'
			jl 		short error
			cmp 	cl, '9'
			jg 		short error

			sub 	cl, '0'
			mul 	bx 		; ax*bx -> (dx, ax)
			add 	ax, cx
			inc 	di
		jmp 	short main_array_cycle

		error:
			lea 	di, error_msg[1]
			mov 	cx, 0
			mov 	cl, error_msg[0]
			call 	OUTPUT_PROC
			mov ax, 4c00h
			int 21h

		end_line:
		cmp 	si, 1
		jne 	short not_negative
			neg 	ax
		not_negative:

		ret
	STR_TO_INT		ENDP


	INT_TO_STR 		PROC NEAR

		mov 	bx, ax
		; https://sites.google.com/site/sistprogr/lekcii1/lek8
		or 	bx, bx
		jns		positive_value
			mov 	al, '-'
			int 	29h
			neg 	bx
		positive_value:
		mov 	ax, bx
		xor 	cx, cx
		mov 	bx, 10

		main_calc_cycle:
			xor 	dx, dx
			div 	bx 		; http://av-assembler.ru/instructions/div.php
			add 	dl, '0'
			push 	dx
			inc 	cx
		test 	ax, ax		; http://av-assembler.ru/instructions/test.php
		jnz 	main_calc_cycle

		print:
			pop 	ax
			int 	29h
		loop 	print

		ret
	INT_TO_STR 		ENDP

	; //////////////////////{ MAIN }/////////////////////

	MAIN 		PROC FAR

		push 	DS
		xor 	ax, ax
		push 	ax

		mov 	ax, DATA_SEG
		mov 	DS, ax


		lea 	di, hello_string[1]
		mov 	cx, 0
		mov 	cl, hello_string[0]
		call 	OUTPUT_PROC

		lea 	dx, input_digit
		call 	INPUT_VALUE

		lea 	di, input_digit[2]
		call 	STR_TO_INT

		call 	INT_TO_STR

		ret
	MAIN 	ENDP

CODE_SEG 	ENDS
END 		MAIN
