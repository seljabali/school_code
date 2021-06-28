;**********************************************************************
;* Function:	This program allows users to enter up to 8 characters.
;*		But only characters and numbersthat are suitable of   
;*		being a Hexadecimal will be echoed on to the screen   
;*		which are 0-9,A-F,a-f(which will be converted to upper
;*		-case automatically). If other characters are entered 
;*		other than the backspace and enter key, a bell will be
;*		sounded off from the comptuer itself. The backspace is
;*		functional in this program, but the user will be      
;*		denied of deleting the instructions of the program    
;*		which are loaded at startup. The enter key terminates 
;*		the program.					      
;*								      
;* Author: 	Sami Eljabali					      
;*								      
;* Version: 	1.0						      
;*								      
;* Date: 	9/29/2004                                             
;*								      
;* Due Date:    9/22/2004                                             
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
;*								      
;*		Model						      
;*								      
;**********************************************************************
	.model small

;**********************************************************************
;*									
;*		Stack							
;*									
;**********************************************************************
	.stack 100h

;**********************************************************************
;*									
;*		Constants						
;*									
;**********************************************************************
BELL		equ	07h			; Alaram
LF		equ	0Ah			; Line Feed
CR		equ	0DH			; Carriage return

;**********************************************************************
;*									
;*		DOS Calls						
;*									
;**********************************************************************
DSPL_CHR	equ	2			; Display a character
READ_CHR	equ	7			; Read a character
DSPL_STR	equ	9			; Display a string
EXIT            equ     4c00H                   ; Return to DOS

;**********************************************************************
;*									
;*		Data Segemnt						
;*									
;**********************************************************************
		.data
function	db	'Hexadecimal Checker v1.0 by Sami Eljabali',CR,
			 LF
                db      'Please enter hexadecimals: ','$'

;**********************************************************************
;*									
;*		Code Segemnt					 	
;*									
;**********************************************************************
		.code
begin: 		mov 	ax,@data		; Setup
		mov 	ds,ax			;   data segement 
						;      register

;**********************************************************************
;*									
;*		Disaplay openning message				
;*									
;**********************************************************************
		mov	dx,offset function	; Displaying 
		mov	ah,DSPL_STR		;	openning	
		int	21h			;		message
		mov	cx,0			; Intializing CX to 0

;**********************************************************************
;*									
;*		Get Character					 	
;*									
;**********************************************************************
get_chr:	mov	ah, READ_CHR		; Read  
		int 	21h			;  a character (put in 
                                                ;                  al)
	
	 	cmp	cx,8			; If user entered 8 
                                                ;  characters then
		je	input_gr_8		;     go to input_gr_8 
						;                 label
		
		cmp	cx,0			; If cursor at the 
						;   beginning of input
		je	input_eq_0		;    then go to 
						;     input_eq_0
						
;**********************************************************************
;*									
;*		Check Character                                         
;*		(In this section, computer checks if the entered key by
;*		 the user is in between 0-9,A-F,a-f by using the ASCII 
;*		 values, excluding the Enter and Backspace keys,since 
;*               they have their unique purposes)
;*						
;**********************************************************************
check_chr:	cmp	al,CR			; If the carriage 
                je      ending                  ;  return is entered 
     						;  then end the program
		
		cmp	al,8			; If backspace got to 
		je	backsp 			;  backsp go to backsp 
						;	label

		cmp	al,'0'			; Compare input to zero
		jae	gr_0			; If character is 
                                                ;  greater or equal 
						;   to '0' go to gr_0

		jmp	alarm 			; If not, go to alarm 
						; label

;**********************************************************************
;*									
;*		Character Greater than '0'				
;*             	(Here the computer is checking if the input is less or 
;*		equal to 9. To determine if it is between 0-9 which 
		would make it valid)
;*						
;**********************************************************************
gr_0:		cmp	al,'9'			; Compare the 
						;      input to 9
		jbe	valid			; If equal or less than 
						; then its a valid input

;**********************************************************************
;*									
;*		Character Greater than '9'			 	
;*	        (Here the computer is checking if the value is below 
;*		 than 'A' in the ASCII table, if so then it is an 
;*		 invalid hexadecimal) 
;*									
;**********************************************************************
gr_9:		cmp	al,'A'			; Compare input to 'A'
		jb	alarm			; If less than 'A' then 
						;   go to alarm

;**********************************************************************
;*							
;*		Character Greater than 'A'		
;*		(Again we are checking if it is between A & F)
;*								
;**********************************************************************
gr_A:		cmp	al,'F'			; Compare input to 'A'
		jbe	valid			; If it is greater or 
						;   equal then its a 
						;        valid input

;**********************************************************************
;*								
;*		Character Greater than 'F'			
;*		(Continuing the comparisons)			
;*								
;**********************************************************************
gr_F:		cmp	al,'a'			; Compare input to 'a'
		jb	alarm			; If it is below 'a' 
						;  then go to alarm

;**********************************************************************
;*									
;*		Character Greater than 'a'			 	
;*		(If the character is greater than 'f' then it is an 
;*		 invalid character else it isn't)	
;*							
;**********************************************************************
gr_lowA:	cmp	al,'f'			; Compare input to 'f'
		ja	alarm			; If it is above  
						;   then go to alarm
						; Else its a valid 
						;   character

;**********************************************************************
;*									
;*		Convert lower case to capital			 	
;*              (Valid characters in lower case form are converted here 
;*		 to upper-case)
;*	
;**********************************************************************
convert:	sub	al,20h			; Convert from lower to 
						;            upper case

;**********************************************************************
;*								
;*		Valid Input  				
;*              (Here after the input was tested to be valid it is 
;*		 printed and CX is incremented by 1 to keep track of 
;*		 printed characters to keep the backspace from deleting 
;*               insturctions)               
;*									
;**********************************************************************
valid:          mov	dl,al			; Setting up 
		mov     ah,DSPL_CHR		;  DOS function 
                int     21h			;   to display the 
						;    valid character

		inc	cx			; Increment CX to keep 
						;       track of cursor

		jmp 	get_chr			; Then get the next 
						;    character

;**********************************************************************
;*								
;*		Number of entries greater than 0        	
;*              (If the cursor is at the beginning of input then deny
;*		 the backspace to fuction. Also sound the bell)
;*								
;**********************************************************************
input_eq_0:	cmp	al,8			; If input equal 8
		je	alarm			;    then go to alarm
		
		cmp	al,CR			; If input equal CR
		je 	alarm			;    then go to alarm
	
                jmp    check_chr                ; then go to check_chr

;**********************************************************************
;*								
;*		Number of entries greater than 8        	
;*		(Denies the user from entering more than 8 characters 
;*		 at a time)
;*			
;**********************************************************************
input_gr_8:	cmp	al,CR			; If input is 'enter'
		je	ending			;   then end program
		
		cmp	al,8			; If it is backspace 
		je	backsp			;  then go to the 
						;    backsp label
		
		jmp	alarm			; Else go to alarm

;**********************************************************************
;*								
;*		Backspace (This is where the backspace is processed)
;*								
;**********************************************************************
backsp:         mov     dl,8h    		; Setting up DOS 
                mov     ah,DSPL_CHR		;    to Display
		int     21h			;         Backspace 
	
		mov	dl,20h			; Setting up DOS 
		int     21h			;  to Display Space
       
                mov     dl,8h    		; Setting up DOS 
		int     21h			; to Display Backspace

		dec	cx			; Decrement CX

		jmp 	get_chr			; Then get another 
						;        character


;**********************************************************************
;*									
;*		Alarm  (This is where the alarm is processed)           
;*									
;**********************************************************************
alarm:		mov	dl,BELL			; Sound alarm since
		mov	ah,DSPL_CHR		;      not 
		int	21h			;  hexadecimal   
		
		jmp	get_chr			; Then get another 
						;        character


;**********************************************************************
;*									
;*		End Program						
;*								        
;**********************************************************************
ending:         mov	ax,EXIT			; Returning controls
		int	21h			;    to DOS
		end     begin                   ; End the program
