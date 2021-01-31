;; main.asm

STACK_SEG 	SEGMENT PARA STACK "STACK"
					db  32 dup ("?")
STACK_SEG 	ENDS

DATA_SEG 	SEGMENT PARA PUBLIC "DATA"
	hello_string 	db 	14, "Input number: "
	input_digit		db 	5, ?, 5 dup("?")
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

		ret
	INPUT_VALUE 	ENDP


	STR_TO_INT 		PROC NEAR
		ret
	STR_TO_INT		ENDP


	INT_TO_STR 		PROC NEAR
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

		; call 	STR_TO_INT

		mov 	cx ,0
		lea 	bx, 2
		num_checking:

			; для позитивных значений
			cmp 	input_digit[bx + cx], '0'
			jl 		short exit

			cmp 	input_digit[bx + cx], '9'
			jb 		short exit

			

			inc 	cx
		cmp 	cl, input_digit[1]
		jl		short num_checking

		exit:
		
		ret
	MAIN 	ENDP

CODE_SEG 	ENDS
END 		MAIN
