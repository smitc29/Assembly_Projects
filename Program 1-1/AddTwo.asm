; Christopher Smith		Project 1-1
; CSCI 231		Professor J Ryder
; Sept 28, 2016
; Subtract 3 integers

TITLE MASM Template
						
INCLUDE Irvine32.inc

; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example


.data
varA	WORD	10
varB	WORD	04
varC	WORD	02
varD	WORD	01

.code
main proc
	mov	ax, varA
	sub	ax, varB				
	sub	ax, varC
	sub	ax, varD
	
	call DumpRegs
	exit
	
	;invoke ExitProcess,0
main endp
end main