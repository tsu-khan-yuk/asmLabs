
STACK_SEG	SEGMENT PARA STACK "STACK"
			db 	64	dup ("STACK")
STACK_SEG	ENDS


DATA_SEG 	SEGMENT PARA PUBLIC "DATA"
	array	db 	10, 20, 30, 40
	dest	db 	4 dup ("?")
DATA_SEG	ENDS


CODE_SEG 	SEGMENT	PARA PUBLIC "CODE"

	MAIN 	PROC FAR

		ASSUME 		CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

		push	ds
		xor 	ax, ax
		push 	ax

		mov 	ax, DATA_SEG
		mov 	ds, ax

		;*
		mov 	dest[0], 0
		mov 	dest[1], 0
		mov 	dest[2], 0
		mov 	dest[3], 0

		mov 	al, array[0]
		mov 	dest[3], al
		mov 	al, array[1]
		mov 	dest[2], al
		mov 	al, array[2]
		mov 	dest[1], al
		mov 	al, array[3]
		mov 	dest[0], al

		ret
	MAIN 	ENDP

CODE_SEG 	ENDS
END 		MAIN
