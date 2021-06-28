
;**********************************************************************
;*		Get Operator
;**********************************************************************
get_op:		mov	ah, READ_CHR		; Read  
		int 	21h			;  a character (al)

		cmp	al,CR			; Compare with CR
		je	ending			;  if equal quit 

		xor	cx,cx			; Clear CX for next num

		cmp	al,2Ah			; Compare with '*' op
		jb	op_alarm		;  if less than alarm
		
		cmp	al,2Bh			; Compare with '+' op
		jbe	push_op			;  if less than alarm

		cmp	al,2Dh			; Compare with '-' op
		je	push_op			;   if equal push

		jmp 	op_alarm		; Else set alarm

;**********************************************************************
;*		Push Operator
;**********************************************************************
push_op:	mov	dl,al			; Setting up 
		mov     ah,DSPL_CHR		;  DOS function 
                int     21h			;   to display the 
						;    valid character	
	
		mov	ah,0			; Clear ah
		push	ax			; If push op to stack
	
		mov	dx,offset newline	; Displaying 
		mov	ah,DSPL_STR		;    a
		int	21h			;  new line
	
		jmp	get_chr			; Get another number


;**********************************************************************	
;*		Operator Alarm   
;**********************************************************************
op_alarm:	mov	dl,BELL			; Sound alarm since
		mov	ah,DSPL_CHR		;      not 
		int	21h			;  operator   
		
		jmp	get_op			; Then get another 
						;        character

;**********************************************************************
;*		End Program						
;**********************************************************************
ending:         mov	ax,EXIT			; Returning controls
		int	21h			;    to DOS
		end     begin                   ; End the program

;**********************************************************************
;*		Convert Hex-ASCII						
;**********************************************************************
conv_hex	proc 

		xor	ax,ax			; Clear ax
		mov	ex,cx			; Conserve # of chrs
		mov	bx,offset inbuf		; Point to 1st chr

next_digit:	;cmp	ex,0			; If gone thru evry chr
		;je	end_func		;   exit the function
		dec	cx			; For multiplying
		mov	al,[bx]			; Get digit
		xor	ah,ah			; Clear ah just incase
		cmp	al,'A'			; See if letter
		jb	convert			; If digit go to convert
		sub	al,'0'+7		; Else convert it to number
		cmp	cx,0			; If last digit
		je	end_func		;  Don't multiply
		jmp	multiply		;  Then go to multiply
	
convert:	sub	al,'0'			; Change the chr to num
		cmp	cx,0			; If last digit
		je	end_func		;  Don't multiply
		
		
multiply:	mul	16			; Converting hex - decimal
		loop 	multiply		; Multiply 16 to # base pos.
		dec	ex			; Decrement ex 
		mov	cx,ex			; Restore cx for next loop
		inc	bx			; Point to next chr
		add	dx,ax			; Add up new num with total
		jmp	next_digit		; Get next digit

end_func:	add	dx,ax			; Since no multiplying needed
		ret				;  for last num just add it
						; Then exit function
conv_hex	endp
