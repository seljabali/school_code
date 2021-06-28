;**********************************************************************
;* Function:				      
;*								      
;* Author: 	Sami Eljabali					      
;*								      
;* Version: 	1.0						      
;*								      
;* Date: 	9/29/2004
;*	      
;* File:	hexchecker.asm                                        
;*								      
;* Input: 	Hexadecimal numbers.				      
;*								      
;* Output: 	Valid hexadecimal characters that are entered from    
;*		user.						      
;*								      
;**********************************************************************

;**********************************************************************
;*		Model						      
;**********************************************************************
	.model small

;**********************************************************************
;*		Stack							
;**********************************************************************
	.stack 100h

;**********************************************************************
;*		Constants						
;**********************************************************************
BELL		equ	07h			; Alaram
LF		equ	0Ah			; Line Feed
CR		equ	0DH			; Carriage return

;**********************************************************************	
;*		DOS Calls						
;**********************************************************************
DSPL_CHR	equ	2			; Display a character
READ_CHR	equ	7			; Read a character
DSPL_STR	equ	9			; Display a string
EXIT            equ     4c00H                   ; Return to DOS

;**********************************************************************
;*		Data Segemnt						
;**********************************************************************
		.data
function	db	'Hexadecimal Calculator v1.0 by Sami Eljabali',
			CR,LF
                db      'Division not supported',CR,LF,
		   	'Hit enter to quit',CR,LF, '$'
newline		db 	CR,LF,'$'
inbuf		db	5 dup (?)

;**********************************************************************
;*		Code Segemnt					 	
;**********************************************************************
		.code
begin: 		mov 	ax,@data		; Setup
		mov 	ds,ax			;   data segement 
						;      register
		mov	bx,offset inbuf

;**********************************************************************
;*		Disaplay openning message		
;**********************************************************************
		mov	dx,offset function	; Displaying 
		mov	ah,DSPL_STR		;	openning	
		int	21h			;		message
		xor	cx,cx			; Intializing CX to 0

;**********************************************************************
;*		Calling get_chr Function
;**********************************************************************
		call	get_chr

;**********************************************************************
;*		Display CR before getting Operator
;**********************************************************************
dsply_CR:	mov	dx,offset newline	; Displaying 
		mov	ah,DSPL_STR		;    a
		int	21h			;  new line

		mov	dx,offset inbuf
		mov	ah,DSPL_STR
		int 	21h
;**********************************************************************
;*		Get operator
;**********************************************************************
;get_op:		mov	ah, READ_CHR		; Read  
;		int 	21h			;  a character (al)
;
;		cmp	al,CR			; Compare with CR
;		je	ending			;  if equal quit 
;
;		xor	cx,cx			; Clear CX for next num
;
;		cmp	al,2Ah			; Compare with '*' op
;		jb	op_alarm		;  if less than alarm
;		
;		cmp	al,2Bh			; Compare with '+' op
;		;jbe	push_op			;  if less than alarm
;
;		cmp	al,2Dh			; Compare with '-' op
;		;je	push_op			;   if equal push
;
;		jmp 	op_alarm		; Else set alarm
;
;**********************************************************************
;*		Calling get_chr Function
;**********************************************************************

;num_func:	call	get_chr


;**********************************************************************	
;*		Operator Alarm   
;**********************************************************************
;op_alarm:	mov	dl,BELL			; Sound alarm since
;		mov	ah,DSPL_CHR		;      not 
;		int	21h			;  operator   
;		
;;		jmp	get_op			; Then get another 
						;        character

;**********************************************************************
;*								      *
;*	       	      *F U N C T I O N S*			      *
;*								      *
;**********************************************************************
		


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;				     ;; 
	;;	     Get Number	      	     ;;	
	;;				     ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_chr		proc
		mov	ah, READ_CHR		; Read  
		int 	21h			;  a character (al)
	
	 	cmp	cx,4			; If user entered 4 
		je	input_gr_4      	;  characters then
			           		;     go to input_gr_4 
		
		cmp	cx,0			; If cursor at the 
		je	input_eq_0		;   beginning of input
						;    then go to 
						;     input_eq_0
						
;**********************************************************************
;*		Check Number
;**********************************************************************
check_chr:	cmp	al,CR			; If CR is entered 
                je      end_func                ;  then get the operator

		cmp	al,8			; If backspace got to 
		je	backsp 			;  backsp go to backsp 
						;	label

		cmp	al,'0'			; Compare to zero
		jae	gr_0			; If greater or equal 
						;   to '0' go to gr_0

		jmp	alarm 			; If not, go to alarm 
						; label
	
gr_0:		cmp	al,'9'			; Compare to 9
		jbe	valid			; If equal or less than 
						; then its a valid input

gr_9:		cmp	al,'A'			; Compare to 'A'
		jb	alarm			; If less than 'A' then 
						;   go to alarm

gr_A:		cmp	al,'F'			; Compare to 'A'
		jbe	valid			; If it is greater or 
						;   equal then its a 
						;        valid input

gr_F:		cmp	al,'a'			; Compare 'a'
		jb	alarm			; If it is below 'a' 
						;  then go to alarm

gr_lowA:	cmp	al,'f'			; Compare 'f'
		ja	alarm			; If above then go 
						;    to alarm
						; Else it valid 

;**********************************************************************
;*		Convert lower case to capital			 
;**********************************************************************
convert:	sub	al,20h			; Convert from lower to 
						;            upper case

;**********************************************************************
;*		Valid Input  					
;**********************************************************************
valid:          mov	dl,al			; Setting up 
		mov     ah,DSPL_CHR		;  DOS function 
                int     21h			;   to display the 
						;    valid character

		inc	cx			; Increment CX to keep 
						;       track of cursor

		jmp 	get_chr			; Then get the next 
						;    character
		mov	[bx],al			; MOVE IT TO INPUT BUFFER
		inc	bx

;**********************************************************************
;*		Number of entries greater than 0        		
;**********************************************************************
input_eq_0:	cmp	al,8			; If input equal 8
		je	alarm			;    then go to alarm
		
		cmp	al,CR			; If input equal CR
		je 	alarm			;    then go to alarm
	
                jmp    check_chr                ; then go to check_chr

;**********************************************************************	
;*		Number of entries greater than 4    
;**********************************************************************
input_gr_4:	cmp	al,CR			; If input is CR
		je	end_func        	;   then get_op
		
		cmp	al,8			; If it is backspace 
		je	backsp			;  then go to the 
						;    backsp label
		
		jmp	alarm			; Else go to alarm

;**********************************************************************	
;*		Backspace 
;**********************************************************************
backsp:         mov     dl,8h    		; Setting up DOS 
                mov     ah,DSPL_CHR		;    to Display
		int     21h			;         Backspace 
	
		mov	dl,20h			; Display
       		int     21h			;    Space
       
                mov     dl,8h    		; Display
		int     21h			;     Backspace 

		dec	cx			; Decrement CX
		dec	bx			; Decrement BX

		jmp 	get_chr			; Then get character		

;**********************************************************************	
;*		Alarm   
;**********************************************************************
alarm:		mov	dl,BELL			; Sound alarm since
		mov	ah,DSPL_CHR		;      not 
		int	21h			;  hexadecimal   
		
		jmp	get_chr			; Then get another 
						;        character

;**********************************************************************
;*		Closing the function  					
;**********************************************************************
end_func:	ret

get_chr		endp

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;				     ;; 
	;;	     Convert Number   	     ;;	
	;;				     ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
conv_num	proc
		xor	ax,ax			; Clear up AX
		mov	bx,offset inbuf		; Make BX to 1st chr
		mov	dl,[bx]		
		cmp	dl,'A'
		jb	next_dec_digit
		
		
next_dec_digit:
		mul	16
		mov	dl,[bx]
		
		jae	next_letter
	
		sub	dl,''0'	
		mov	dh,0
		add	ax,dx
		dec	bx
		loop	next_dec_digit
		
		jmp	get_op

next_letter:	sub	dl,''0'+7	
		mov	dh,0
		add	ax,dx
		dec	bx
		jmp	next_dec_digit
conv_num	endp
;**********************************************************************
;*		End Program						
;**********************************************************************
ending:         mov	ax,EXIT			; Returning controls
		int	21h			;    to DOS
		end     begin                   ; End the program