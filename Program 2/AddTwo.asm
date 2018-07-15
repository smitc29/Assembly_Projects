; Christopher Smith		Project 2
; CSCI 231		Professor J Ryder
; Oct 2, 2016
; Reverse a string

TITLE MASM Template
						
INCLUDE Irvine32.inc

.data
source BYTE "This is the source string",0
target BYTE SIZEOF source DUP('#')

.code
main proc
	
	mov ebx, [SIZEOF source]-1 ; Find location for last character of source string

	;mov ebx, [SIZEOF source]
	;dec ebx    ;alternate way to code if previous "ebx" line didn't want to copperate

	mov esi, ebx ; Copies location for last character of string into seperate mem address

	mov edi, 0 ; Sets location for target string array's [0] spot

	mov ecx, [SIZEOF source] ; Sets counter for loop, size equal to source string
	;mov ecx, [ebx]+1 ; For some reason, this throws an exception; will assemble but not run

reword: 
	mov al, source[esi]     ; Finds can copies current character of string
	mov target[edi], al     ; Copies character from eax low register to target
	dec esi                 ; Decrements mem location to previous character of source
	inc edi                 ; Increments mem location to next character of target

	loop reword

	mov    esi,OFFSET target
	mov    ebx,1
	mov    ecx,SIZEOF target
	call DumpMem 

	exit
	
main endp
end main