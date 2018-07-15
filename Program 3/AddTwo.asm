; Christopher Smith		Project 3
; CSCI 231		Professor J Ryder
; Oct 2, 2016
; Changing colors, testing plaindromes, consent loop

TITLE MASM Template
						
INCLUDE Irvine32.inc

.data
source BYTE "This is the source string",0
prompt1 BYTE " Please enter a string: ", 0
prompt2 BYTE " Would you like to continue? ('Y' or 'y' to continue) ", 0
prompt3 BYTE " Entered String: ", 0
prompt4 BYTE " Reversed String: ", 0

success BYTE " This String is a Palindrome! ",0
failure BYTE " This String is NOT a Palindrome... ",0

string3 BYTE SIZEOF source DUP ('#')   ;User enters data into this string
string4 BYTE SIZEOF string3 DUP('#')   ;Filters string3 into Caps
string5 BYTE SIZEOF string3 DUP('#')   ;Reversed version of String4
target BYTE SIZEOF string3 DUP('#')   ;Reversed version of string3

counter dword ? ; Used as its namesake

.code

main PROC

	call chancolor ; Changes background/foreground colors

	Consent:

	call Clrscr

	call Reseter; Resets all strings to null, prevents errors 	

	call Filter ; strips string3 down to capital letters, puts into string4

	call Reverse ; Reverses string3 and places it in target
	
	call Flip ; Reverses string4, places duplicate into string5 

	call Versus ; Tests to see if a string is a palindrome // PRESENTLY doesn't output target, but copies data into it

	mov    ecx,SIZEOF string5 ; For some reason, without this line the program doesn't work

	call CrLf
	mov edx, OFFSET prompt2
	call WriteString
	mov edx, OFFSET string3
	call ReadString			

	cmp string3[0], 'y'
	JE Consent
	cmp string3[0], 'Y'
	JE Consent

    call DumpRegs
	call altcolor  ; Reset screen to default colors, clears screen

	exit
main ENDP


chancolor PROC		; Sets the background to blue, text to yellow

mov eax, 01Eh

call SetTextColor
call Clrscr

ret
chancolor ENDP


altcolor PROC		; Resets text and background colors to default

mov eax, 007h

call SetTextColor
call Clrscr

ret
altcolor ENDP


Filter PROC		; strips String down to capital letters, puts into string4

	call CrLf
	mov edx, OFFSET prompt1
	call WriteString

mov edx, OFFSET string3				;Moves location of string3 to edx
	mov ecx, SIZEOF string3			;Copies size of string3 into ecx
	call ReadString
	mov counter, eax				;Measures <Actual> size of string entered
	call CrLf
	mov ecx, counter ; Sets counter for a loop
	mov esi, 0
	mov edi, 0 

	 Strip:

		mov al, string3[esi] ; Puts char into al

		cmp al, 'A' ; Compares 'A' to al character
		JB Under_A ; If al < 'A', skip to end of loop
		cmp al, 'Z' ; Compares 'A' to al character
		JA Over_Z ; If al > 'Z', skip to end of loop

		mov string4[edi], al ; Move capital letter into String4
		inc edi				 ; Prepare for incoming char
		jmp Uppercase ; Jumps to end of loop if it is uppercase

		Over_Z: 
		cmp al, 'a' ; Compares 'a' to al character
		JB Under_SMA ; If al < 'a', skip to end of loop
		cmp al, 'z' ; Compares 'A' to al character
		JA Over_SMZ ; If al > 'z', skip to end of loop
		
		sub al, 20h ; Makes lowercase letter into uppercase
		mov string4[edi], al ;Puts uppercase letter into new string
		inc edi				 ; Prepare for incoming char  

		Under_A:
		Under_SMA:
		Over_SMZ:
		Uppercase:

		inc esi ; point to next char in string3

		loop Strip

ret
Filter ENDP


Flip PROC		; Reverses string (only accepting capital letters)

	mov esi, 0
	mov ebx, 0
L1:
		; At this point, string is all capitals or null / '#'
	mov al, string4[esi] ; Puts char into al 
	
	cmp al, 'A' ; Compares 'A' to al character
	JB EndL2 ; If al < 'A', skip to end of loop
	cmp al, 'Z' ; Compares 'A' to al character
	JA EndL2 ; If al > 'Z', skip to end of loop

	inc esi ; move to next char in string
	inc ebx ; Increase size of string by 1

loop L1
	
	EndL2: 

	dec ebx ;Set bx to be last character of source string  
	;mov ebx, [SIZEOF string4]-1 ; Find location for last character of source string

	;mov ebx, [SIZEOF string4]
	;dec ebx    ;alternate way to code if previous "ebx" line didn't want to copperate

	mov esi, ebx ; Copies location for last character of string into seperate mem address

	mov edi, 0 ; Sets location for target string array's [0] spot

	mov ecx, [SIZEOF string4] ; Sets counter for loop, size equal to source string
	;mov ecx, [ebx]+1 ; For some reason, this throws an exception; will assemble but not run

reword: 
	mov al, string4[esi]     ; Finds can copies current character of string

	cmp al, 'A' ; Compares 'A' to al character
	JB EndL1 ; If al < 'A', skip to end of loop
	cmp al, 'Z' ; Compares 'A' to al character
	JA EndL1 ; If al > 'Z', skip to end of loop

	mov string5[edi], al     ; Copies character from eax low register to target
	dec esi                 ; Decrements mem location to previous character of source
	inc edi                 ; Increments mem location to next character of target

	loop reword
	EndL1:

ret
Flip ENDP


Versus PROC		; Resets text and background colors to default

mov edi, 0 ; Sets location for target string array's [0] spot
mov esi, 0 
mov ecx, [SIZEOF string4] ; Sets counter for loop, size equal to source string

L3:
	mov al, string5[edi]
	mov bl, string4[edi]
	cmp al, bl ; Compares same spot in both strings
	JB Nmatch ; If the char is either too big or too small,
	JA Nmatch ; it's not a perfect match, so we jump to the end
	inc edi ; Move to next value in strings

loop L3

	mov edx, OFFSET success ; String is a palindrome!
	call WriteString
	call CrLf				; Line Break
	mov edx, OFFSET prompt3
	call WriteString
	mov edx, OFFSET string3
	call WriteString
	call CrLf
	mov edx, OFFSET prompt4
	call WriteString
	
	mov ecx, SIZEOF string3
	mov ebx, 0 ; blank counter
	mov edi, 0 ;string counter

	Blank:
	mov al, target[edi]
	cmp al, '#'
	JA Tinyhop
	JB Tinyhop
	inc ebx
	inc edi
	TinyHop:
	loop Blank

	mov edx, OFFSET target
	add edx, ebx
	add edx, 2 ; Don't know why, but without this statement it just doesn't work
	call WriteString

	jmp Match ; We know the string is a palindrome, end the procedure

	Nmatch:
	mov edx, OFFSET failure ; String is not a palindrome
	call WriteString
	call CrLf
	mov edx, OFFSET prompt3
	call WriteString
	mov edx, OFFSET string3
	call WriteString
	call CrLf
	mov edx, OFFSET prompt4
	call WriteString

	mov ecx, SIZEOF string3
	mov ebx, 0 ; blank counter
	mov edi, 0 ;string counter

	Blankx:             ; Loop specifically designed to ensure right position is located
	mov al, target[edi]
	cmp al, '#'
	JA Tinyhop2
	JB Tinyhop2
	inc ebx
	inc edi
	TinyHop2:
	loop Blankx

	mov edx, OFFSET target
	add edx, ebx
	add edx, 2 ; Don't know why, but without this statement it just doesn't work
	call WriteString


	Match:
ret
Versus ENDP


Reverse PROC 

	mov ebx, [SIZEOF string3]-1 ; Find location for last character of source string

	mov esi, ebx ; Copies location for last character of string into seperate mem address

	mov edi, 0 ; Sets location for target string array's [0] spot

	mov ecx, [SIZEOF string3] ; Sets counter for loop, size equal to source string
	;mov ecx, [ebx]+1 ; For some reason, this throws an exception; will assemble but not run

reword2: 
	mov al, string3[esi]     ; Finds can copies current character of string

	mov target[edi], al     ; Copies character from eax low register to target
	inc edi                 ; Increments mem location to next character of target

	dec esi                 ; Decrements mem location to previous character of source
	loop reword2

ret 
Reverse ENDP

Reseter PROC

mov ecx, SIZEOF string3
mov edi, 0
reword3:      ; Finds can copies current character of string

	mov string3[edi], '#'     ; Copies '#' string3
	mov string4[edi], '#'     ; Copies '#' string4
	mov string5[edi], '#'     ; Copies '#' string5
	mov target[edi], '#'     ; Copies '#' target
	inc edi                 ; Increments mem location to next character of string4

	loop reword3

ret 
Reseter ENDP

END main