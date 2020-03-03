[ORG 0x00]
[BITS 16]

SECTION .text

jmp 0x07C0:START

TOTAL_SECTOR_COUNT:	dw 1 

START:
	mov ax, 0x07C0 ; BOOT Loader Start Address
	mov ds, ax
	mov ax, 0xB800 ; Video Memory Start Address
	mov es, ax

	mov ax, 0x000
	mov ss, ax
	mov sp, 0xFFFE
	mov bp, 0xFFFE

	mov si, 0

.SCREEN_CLEAR_LOOP:
	mov byte [es: si] , 0
	mov byte [es: si + 1], 0
	add si,2
	cmp si, 80 * 25 * 2 ; screen total size

	jl .SCREEN_CLEAR_LOOP:

	push msg1
	push 0
	push 0
	call PRINT_MSG
	add sp, 6

	push IMAGE_LOADING_MSG
	push 1
	push 0
	call PRINT_MSG
	add sp, 6

RESET_DISK:
	mov ax, 0 
	mov dl, 0 
	int 0x13
	jc HANDLE_DISK_ERROR

	mov si, 0x1000
	mov es, si
	mov bx, 0x0000
	mov di, word[TOTAL_SECTOR_COUNT]

READ_DATA:
	cmp di, 0
	je READ_END
	sub di, 0x1

	; CALL BIOS Read Function 

	mov ah, 0x02 ; BIOS Service Number 2 --> Read Sector
	mov al, 0x1 ; To Read Sector Number
	mov ch, byte[TRACK_NUMBER]
	mov cl, byte[SECTOR_NUMBER]
	mov dh, byte[HEADNUMBER]
	mov dl, 0x00
	int 0x13
	jc HANDLE_DISK_ERROR

	add si, 0x20
	mov es, si

	mov al, byte[SECTOR_NUMBER]
	add al, 0x01

	mov byte[SECTOR_NUMBER], al
	cmp al, 19
	jl READ_DATA

	; if SECTOR NUMVER > = 19 --> GOGO
	xor byte[HEAD_NUMBER], 0x01
	mov byte[SECTOR_NUMBER], 0x01

	cmp byte[HEAD_NUMBER], 0x00
	jne READ_DATA

	add bytep[TRACK_NUMBER], 0x01
	jmp READ_DATA
READ_END:

	push LOADING_COMPLETE_MSG
	push 1
	push 20
	call PRINT_MSG
	add sp, 6

	jmp 0x1000:0x0000

HANDLE_DISK_ERROR:
	push DISK_ERROR_MSG
	push 1
	push 20
	call PRINT_MSG

	jmp $

PRINT_MSG:
	push bp
	mov bp, sp
	push es
	push si
	push di
	push cs
	push dx

	mov ax, 0xB800 ; Video memory Start Address
	mov es,ax

	mov ax, word[bp + 6]
	mov si, 160
	mul si
	mov di, ax
	mov ax, word[bp + 4]
	mov si, 2
	mul si
	add di, ax

	mov si, word[bp + 8]

.MSG_LOOP:
	mov cl, byte[si]
	cmp cl, 0
	je .MSG_END
	mov byte[es : di], cl

	add si, 1
	add di, 2

	jmp .MSG_LOOP

.MSG_END:
	pop dx
	pop cs
	pop ax
	pop di
	pop si
	pop es
	pop bp
	ret

; DATA location

MSG1: db 'JANGEUNTAE OS Boot Loader Start!!',0
DISK_ERROR_MSG: db 'DISK ERROR!!',0
IMAGE_LOADING_MSG: db 'Image Loading...',0
LOADING_COMPLETE_MSG db 'MESSAGE Loading Complete!!',0

SECTOR_NUMBER:  db 02
HEAD_NUMBER:    db 0x00
TRACK_NUMBER db 0x00

times 510 - ($ - $$) db 0x00

db 0x55
db 0xAA
