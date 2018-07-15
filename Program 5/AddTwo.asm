; Christopher Smith		Project 5
; CSCI 231		Professor J Ryder
; Nov 1, 2016
; Determining Factors/Remainders from dividing values

TITLE MASM Template
						
INCLUDE Irvine32.inc

.data
source BYTE "This is the source string",0
prompt1 BYTE " Please enter a 4 digit hex value (No spaces): ", 0
prompt2 BYTE " Would you like to continue? ('Y' or 'y' to continue) ", 0
prompt3 BYTE " You entered the following value: ", 0
prompt4 BYTE " Hex Number is: ", 0
prompt5 BYTE " - ", 0

string3 BYTE 5 DUP (0), 0

var1 WORD 0
var2 WORD 0
var3 WORD 0
var4 WORD 0

counter dword ? ; Used as its namesake

.code

main PROC

	Consent:

		mov    ecx,SIZEOF string3 ; For some reason, without this line the program doesn't work

	call Clrscr
	call CrLf
	mov edx, OFFSET prompt1
	call WriteString
	mov edx, OFFSET string3
	call ReadString	

	mov eax, 0 ; Ensures output from last run is gone if repeating
	mov ebx, 0 ;

	mov bl, string3[0] ;	Put first hex value of string into var1
	call Filter
	mov var1, bx
	mov ax, var1	;	Places var1 into ax register and shifts it over 4 bits
	SHL ax, 4

	mov bl, string3[1] ;	Put second hex value of string into var2
	call Filter
	mov var2, bx
	add ax, var2	;	Places var2 into ax register and shifts it over 4 bits
	SHL ax, 4

	mov bl, string3[2] ;	Put third hex value of string into var3
	call Filter
	mov var3, bx
	add ax, var3	;	Places var3 into ax register and shifts it over 4 bits
	SHL ax, 4

	mov bl, string3[3] ;	Put fourth hex value of string into var4
	call Filter
	mov var4, bx
	add ax, var4	;	Places var4 into ax register 

	call Outputter

	call CrLf
	call CrLf
	mov edx, OFFSET prompt2
	call WriteString
	call ReadChar			

	cmp al, 'y'
	JE Consent
	cmp al, 'Y'
	JE Consent

    call DumpRegs

	exit
main ENDP



Filter PROC		; strips String down to capital letters, puts into string4


		cmp bl, '0' ; Compares '0' to bl character
		JB Under_0 ; If cl < '0', skip to end of loop
		cmp bl, '9' ; Compares '9' to bl character
		JA Over_9 ; If al > '9', skip to letter check

		sub bl, 30h ; Turns char value into hex value
		jmp Number ; Jumps to end of loop if it is number

		Over_9: 
		cmp bl, 'A' ; Compares 'A' to bl character
		JB Under_A ; If al < 'A', skip to end of loop
		cmp bl, 'F' ; Compares 'F' to bl character
		JA Over_F ; If al > 'F', skip to end of loop
		
		sub bl, 37h ; Makes letter into corresponding hex value

		Under_0:
		Under_A:
		Over_F:
		Number:

ret
Filter ENDP

Outputter PROC

mov ebx, eax

call CrLf
	call CrLf
	mov edx, OFFSET prompt3
	call WriteString
	mov edx, 0
	mov al, string3[0]
	call WriteChar
	mov edx, OFFSET prompt5
	call WriteString
		mov edx, 0
	mov al, string3[1]
	call WriteChar
	mov edx, OFFSET prompt5
	call WriteString
		mov edx, 0
	mov al, string3[2]
	call WriteChar
	mov edx, OFFSET prompt5
	call WriteString
		mov edx, 0
	mov al, string3[3]
	call WriteChar

	call CrLf
	mov edx, OFFSET prompt4
	call WriteString
	mov eax, ebx
	mov ebx,TYPE WORD
	call WriteHexB
ret
Outputter ENDP

END main