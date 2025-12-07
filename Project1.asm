;######################################################
;Project 1:	This program calculates the following 
;			expression after adding array elements 
;			to data labels (num1, num2, num3, num4):
;			total = (num3 + num4) - (num1 + num2) + 1
;
;Student Name: Malcolm Dyer
;Course Number: 41958
;Project Number: 1
;Date: 9/11/2025
;######################################################

include Irvine32.inc
.data
	arrayW word 1000h, 2000h, 3000h, 4000h
	num1 word 1
	num2 word 2
	num3 word 4
	num4 word 8
	total word ?
.code
main proc
	mov ax, [arrayW]	;;;;;	this section is adding 
	add ax, num1			;	the array elements to the
	mov num1, ax			;	corresponding variables
	mov ax, [arrayW+2]		;
	add ax, num2			;
	mov num2, ax			;
	mov ax, [arrayW+4]		;
	add ax, num3			;
	mov num3, ax			;
	mov ax, [arrayW+6]		;
	add ax, num4			;
	mov num4, ax			;

	mov bx, num3		;;;;;	this section is doing:
	add bx, num4			;	total = (num3 + num4) - (num1 + num2) + 1
	mov ax, num1			;
	add ax, num2			;
	sub bx, ax				;
	inc bx					;
	mov total, bx			;

	mov esi, offset total	;	checking the value of total
exit
main endp
end main