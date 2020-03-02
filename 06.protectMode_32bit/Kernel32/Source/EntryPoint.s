[ORG 0x00]
[BITS 16]

SECTION .text

START:
	mov ax, 0x1000; protect mode entry point start address(0x1000)
	mov ds, ax
	mov es, ax
	cli ; setting to protect interrupt 

	lgdt [GDTR]
	
	mov eax, 0x4000003B
	mov cr0, eax
	jmp dword 0x08: (PROTECTED_MODE - $$ + 0X10000)

[BITS 32]
PROTECTED_MODE:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ss, ax
	mov esp, 0xFFFE
	mov ebp, 0xFFFE

	push (SWITCH_SUCCESS_MSG - $$ + 0X10000)
	push 2
	push 0
	call PRING_MSG

	add esp, 12

	jmp $

PRINT_MSG:
	push ebp
	mov ebp, esp
	push esi
	push edi
	push eax
	push ecx
	push edx

	mov eax, dword [ebp + 12]
	mov esi, 160
	mul esi
	mov edi, eax
	mov eax, dword[ebp + 8]
	mov esi, 2
	mul esi
	add edi, eax

	mov esi, dword[ebp + 16]

.MSG_LOOP:
	mov cl, byte[esi]
	cmp cl, 0
	je .MSG_END

	mov byte [edi + 0xB8000], cl
	add esi, 1
	add edi, 2

	jmp .MSG_LOOP

.MSG_END:
	pop edx
	pop ecx
	pop eax
	pop edi
	pop esi
	pop ebp
	ret 
align 8, db 0
dw 0x0000

GDTR:
	dw GDTEND-GDT-1
	dd (GDT - $$ + 0X10000)

GDT:
	NULLDESCRIPTOR:
		dw 0x0000
		dw 0x0000
		db 0x00
		db 0x00
		db 0x00
		db 0x00
	
	CODESCRIPTOR:
		dw 0xFFFF
		dw 0x0000
		db 0x00
		db 0x9A
		db 0xCF
		db 0x00

	DATADESCRIPTOR:
		dw 0xFFFF
		dw 0x0000
		dw 0x00
		db 0x92
		db 0xCF
		db 0x00
GDTEND:
SWITCH_SUCCESS_MSG: db 'Switch to Protected Mode Success!!',0

times 512 - ($ - $$) db 0x00
