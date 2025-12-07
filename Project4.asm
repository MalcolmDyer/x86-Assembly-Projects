;######################################################
;Project 4:	This program displays stack addresses and 
;           32-bit values which are pushed on the 
;           stack when the procedures are called. 
;           The contents are displayed in order from 
;           the lowest address to the highest address.
;
;Student Name: Malcolm Dyer
;Course Number: 41958
;Project Number: 4
;Date: 12/6/2025
;######################################################

INCLUDE Irvine32.inc

;---------------------------------------------------------
; Macro: displayText text[, newLine]
; Uses WriteString (and Crlf if newLine is present)
;---------------------------------------------------------
displayText MACRO text:REQ, newLine:VARARG
    push edx
    mov  edx, OFFSET text
    call WriteString
    IFNB <newLine>
        call Crlf
    ENDIF
    pop  edx
ENDM

.DATA
; data labels (contents: 1H .. 5H)
val1    DWORD 00000001h
val2    DWORD 00000002h
val3    DWORD 00000003h
val4    DWORD 00000004h
val5    DWORD 00000005h

; number of labels above
counter DWORD ($ - val1) / TYPE val1

; text constants
titleTxt BYTE "System Parameters on Stack",0
lineTxt  BYTE "-----------------------------------------",0
addrTxt  BYTE "Address: ",0
contTxt  BYTE " => Content: ",0
hTxt     BYTE "H",0

.CODE
main PROC
    mov ecx, counter
    lea esi, val5             ; start with last label
push_loop:
    push DWORD PTR [esi]
    sub  esi, TYPE val1
    loop push_loop

    call passCounter

    ; remove the data labels from the stack (C calling convention)
    mov eax, counter
    shl eax, 2                ; * 4 bytes each
    add esp, eax

    exit
main ENDP

;---------------------------------------------------------
; passCounter: pushes counter, calls printStackLocations
;---------------------------------------------------------
passCounter PROC
    push counter              ; argument: number of stack values
    call printStackLocations
    add  esp, 4               ; caller cleans (C convention)
    ret
passCounter ENDP

;---------------------------------------------------------
; printStackLocations(counter)
; prints addresses and contents of the pushed data labels
; from lowest address to highest address.
;---------------------------------------------------------
printStackLocations PROC
    push ebp
    mov  ebp, esp

    displayText titleTxt, 1
    displayText lineTxt, 1

    mov ecx, [ebp+8]
    lea esi, [ebp+16]

print_loop:
    displayText addrTxt
    mov eax, esi              ; print address
    call WriteHex

    displayText contTxt
    mov eax, [esi]            ; print content
    call WriteHex
    displayText hTxt, 1

    add esi, 4
    loop print_loop

    pop ebp

    displayText lineTxt, 1
    ret
printStackLocations ENDP

END main
