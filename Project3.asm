;######################################################
;Project 3:	This project writes a program that controls
;			a laser system at a medical devices company.
;			It has a start (y/n) input, a laser state 
;			display, a ready (y/n) input, and a fire (y/n)
;			input to fire the laser.
;
;Student Name: Malcolm Dyer
;Course Number: 41958
;Project Number: 3
;Date: 11/7/2025
;######################################################

include Irvine32.inc
.data
	; ---- Messages ----
	systemTitleText		byte "Medical Laser System",0
	controlByteText		byte "Control byte value: ",0
	standbyText			byte "System in standby.",0
	readyText			byte "System in ready.",0
	firedText			byte "System fired",0
	shutdownText		byte "System shutdown",0
	
	; ---- Prompts ----
	startPrompt		byte "Start? (y/n): ",0
	readyPrompt		byte "Ready? (y/n): ",0
	firePrompt		byte "Fire? (y/n): ",0

	; ---- Variables ----
	yesNoInput byte 2 DUP(0)	; need one additional byte for null terminator
	controlByte byte 0
.code
main proc
	mov edx,offset systemTitleText
	call writeString
	call crlf
	call printControlByte

	START:
		call crlf
		mov controlByte,0			; clear controlByte
		mov edx,offset startPrompt
		call writeString

		mov edx,offset yesNoInput
		mov ecx,2
		call readString
		cmp yesNoInput,"n"
		jz SHUTDOWN
		cmp yesNoInput,"y"
		jne START
		
		or controlByte, 10000000b	; set bit 7
		call printControlByte

		mov al,controlByte
		rcl al,1					; double check 7th bit and restart if not set
		jnc START					

	STANDBY:
		call crlf
		and controlByte, 11111110b	; clear bit 0 and preserve others
		mov edx,offset readyPrompt
		call writeString

		mov edx,offset yesNoInput
		mov ecx,2
		call readString
		cmp yesNoInput,"n"
		jz START
		cmp yesNoInput,"y"
		jne STANDBY

		or controlByte, 00000001b	; set bit 0
		call printControlByte

		mov al,controlByte
		rcr al,1					; double check bit 0 and restart if not set
		jnc STANDBY

	READY:
		call crlf
		and controlByte, 10000001b	; clear bits 1-6 and preserves bits 0,7

		mov al,controlByte
		rcl al,1					; double check 7th bit and restart if not set
		jnc START
		rcr al,1
		rcr al,1					; double check bit 0 and restart if not set
		jnc STANDBY

		mov edx,offset firePrompt
		call writeString

		mov edx,offset yesNoInput
		mov ecx,2
		call readString
		cmp yesNoInput,"n"
		jz STANDBY
		cmp yesNoInput,"y"
		jne READY

		mov edx,offset firedText
		call writeString
		call crlf
		call crlf
		jmp READY
		
	SHUTDOWN:
		mov edx,offset shutdownText
		call writeString
exit
main endp

printControlByte proc
	push eax
	mov edx,offset controlByteText
	call writeString
	movzx eax,controlByte
	call writeDec
	call crlf
	pop eax
	ret
printControlByte endp

end main