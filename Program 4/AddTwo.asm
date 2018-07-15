; Christopher Smith		Project 4
; CSCI 231		Professor J Ryder
; Nov 1, 2016
; Determining Factors/Remainders from dividing values

TITLE MASM Template
						
INCLUDE Irvine32.inc

.data
source BYTE "This is the source string",0
prompt1 BYTE " Please enter a number of cents between 0 - 99: ", 0
prompt2 BYTE " Would you like to continue? ('Y' or 'y' to continue) ", 0
output1 BYTE " You can exchange that for ", 0
output2 BYTE " quarter(s), ", 0
output3 BYTE " dime(s), and ", 0
output4 BYTE " penny(pennies). ", 0

coin_value DWORD ?
number DWORD ?
amount_left DWORD 0
NumQuar DWORD 0
NumDime DWORD 0
NumPenn DWORD 0

counter dword ? ; Used as its namesake

.code

main PROC

	call chancolor ; Changes background/foreground colors

	Consent:

	call Clrscr
	call CrLf
	mov edx, OFFSET prompt1
	call WriteString
	mov edx, OFFSET amount_left
	call ReadInt	
	mov amount_left, eax

	mov coin_value, 25 ; How many quarters fit into this amount?
	call compute_coin
	mov ecx, number
	mov NumQuar, ecx

	mov coin_value, 10 ; How many dimes fit into this amount?
	call compute_coin
	mov ecx, number
	mov NumDime, ecx
	mov ecx, amount_left ; How many pennies fit into this amount?
	mov NumPenn, ecx  

	call Outputter ; outputs all info from program thus far

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

compute_coin PROC		; Determines how many of a certain type of coin can be traded for change

mov ebx, coin_value
mov eax, amount_left
div bl
mov ecx, 0
mov cl, al
mov number, ecx
mov ecx, 0
mov cl, ah
mov amount_left, ecx

ret
compute_coin ENDP

outputter PROC		; Outputs info in an organized manner

call CrLf
	mov edx, OFFSET output1
	call WriteString
	mov eax, NumQuar
	call WriteDec
	mov edx, OFFSET output2
	call WriteString
	mov eax, NumDime
	call WriteDec
	mov edx, OFFSET output3
	call WriteString
	mov eax, NumPenn
	call WriteDec
	mov edx, OFFSET output4
	call WriteString

ret
outputter ENDP

END main