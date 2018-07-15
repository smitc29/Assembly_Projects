TITLE MASM Template						(main.asm)

INCLUDE Irvine32.inc
includelib irvine32.lib

; Christopher Smith		Project 1-2
; CSCI 231		Professor J Ryder
; Sept 28, 2016
; Declare various variables (All but Real)

.data
varA	BYTE	2
varB	SBYTE	20
varC	WORD	20
varD	SWORD	20
varE	DWORD	20
varF	SDWORD	20
varG	FWORD	20
varH	QWORD	20
varI	TBYTE	20
varJ	REAL4	1.5
varK	REAL8	1.0e-25
varL	REAL10	1.2594e+10

.code
main proc
	mov	al, varA
	mov	ah, varB				
			
	call DumpRegs
	exit
	;invoke ExitProcess,0
main endp
end main