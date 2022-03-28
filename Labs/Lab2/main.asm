; Configure Direction PORT B
ldi r16, 0b00111111 ; digital pins from 8 to 13 of the Arduino
out DDRB, r16
; Configure Direction PORT D
ldi r17, 0b11111100 ; digital pins from 2 to 7 of the Arduino
out DDRD, r17

; r18 and r19 register used for PORT B and PORT D, respectively
ldi r20, 0x00 ; register used for the unit counter
ldi r21, 0x00 ; register used for the decimal counter
ldi r22, 64   ; register used for the timer
ldi r23, 20   ; register used for the timer
ldi r24, 2    ; register used for the timer

loop:
	call set_0XXX				; call subroutine that turn on the 1st digit
	call set_X0XX				; call subroutine that turn on the 2nd digit
	rjmp set_decimal_long_jump	; jump to a branch closer to the subroutine set_decimal
	jump_back_decimals:			; branch used to return after set_decimal
	rjmp set_unit_long_jump		; jump to a branch closer to the subroutine set_unit
	jump_back_units:			; branch used to return after set_unit
	subi r22, 1
	sbci r23, 0
	sbci r24, 0
	cpi r24,0x00				; r24 == 0 means that a certain amount of time has passed. Therefore, we need to update r20 (the unit counter)
	breq update_time_counter	; if r24 == 0 go to update_time_counter (this means don't repeat the loop yet)
	rjmp loop					; else repeat the loop 

	update_time_counter:
		ldi r22, 64			; reset the values of the registers
		ldi r23, 20			; used for the timer
		ldi r24, 2
		inc r20
		cpi r20, 0x0A			; r20 == 10 means that we need to update the decimal counter
		breq update_decimal		; if r20 == 10 go to update_decimal (this means don't repeat the loop yet)
		rjmp loop				; else repeat the loop 

	update_decimal:
		ldi r20, 0x00					; r20 is reset again to 0
		inc r21
		cpi r21, 0x0A					; r21 == 10 means that we need to reset r20 to 0
		breq set_decimal_counter_to_0	; if r21 == 10 go to set_decimal_counter_to_0 (this means don't repeat the loop yet)
		rjmp loop						; else repeat the loop 

	set_decimal_counter_to_0:
		ldi r21, 0x00					; r21 is reset again to 0
		rjmp loop						; repeat the loop

; each of the subroutines set_XXXX reset the values of r18 and r19, and then change the values of r18 and r19 
; to the values needed to show that digit
set_0XXX:
	ldi r18, 0b00111100
	out PORTB, r18
	ldi r19, 0b00000000
	out PORTD, r19
	ldi r18, 0b00111000
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret

set_X0XX:
	ldi r18, 0b00111100
	out PORTB, r18
	ldi r19, 0b00000000
	out PORTD, r19
	ldi r18, 0b00110110
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret

set_decimal_long_jump:
	call set_decimal			; call subroutine that turn on the 3nd digit
	rjmp jump_back_decimals		; jump back to the original part of the code

set_decimal:					; compare r21 with values between 0-9 to decide
	ldi r18, 0b00111100			; which number to show on the third digit
	out PORTB, r18
	ldi r19, 0b00000000
	out PORTD, r19
	cpi r21, 0x01				
	breq set_XX1X
	cpi r21, 0x02
	breq set_XX2X
	cpi r21, 0x03
	breq set_XX3X
	cpi r21, 0x04
	breq set_XX4X
	cpi r21, 0x05
	breq set_XX5X
	cpi r21, 0x06
	breq set_XX6X
	cpi r21, 0x07
	breq set_XX7X
	cpi r21, 0x08
	breq set_XX8X
	cpi r21, 0x09
	breq set_XX9X
	cpi r21, 0x00
	breq set_XX0X

set_XX1X:
	ldi r18, 0b00101100
	out PORTB, r18
	ldi r19, 0b00011000
	out PORTD, r19
	ret

set_XX2X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b01101100
	out PORTD, r19
	ret	

set_XX3X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b00111100
	out PORTD, r19
	ret

set_XX4X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b10011000
	out PORTD, r19
	ret

set_XX5X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b10110100
	out PORTD, r19
	ret	

set_XX6X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b11110100
	out PORTD, r19
	ret

set_XX7X:
	ldi r18, 0b00101100
	out PORTB, r18
	ldi r19, 0b00011100
	out PORTD, r19
	ret

set_XX8X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret

set_XX9X:
	ldi r18, 0b00101101
	out PORTB, r18
	ldi r19, 0b10111100
	out PORTD, r19
	ret

set_XX0X:
	ldi r18, 0b00101100
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret

set_unit_long_jump:
	call set_unit			; call subroutine that turn on the 4nd digit
	rjmp jump_back_units	; jump back to the original part of the code

set_unit:					; compare r20 with values between 0-9 to decide
	ldi r18, 0b00111100
	out PORTB, r18
	ldi r19, 0b00000000
	out PORTD, r19
	cpi r20, 0x01			; compare r20 with values between 0-9 to decide
	breq set_XXX1			; which number to show on the fourth digit
	cpi r20, 0x02
	breq set_XXX2
	cpi r20, 0x03
	breq set_XXX3
	cpi r20, 0x04
	breq set_XXX4
	cpi r20, 0x05
	breq set_XXX5
	cpi r20, 0x06
	breq set_XXX6
	cpi r20, 0x07
	breq set_XXX7
	cpi r20, 0x08
	breq set_XXX8
	cpi r20, 0x09
	breq set_XXX9
	cpi r20, 0x00
	breq set_XXX0

set_XXX1:
	ldi r18, 0b00011100
	out PORTB, r18
	ldi r19, 0b00011000
	out PORTD, r19
	ret

set_XXX2:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b01101100
	out PORTD, r19
	ret

set_XXX3:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b00111100
	out PORTD, r19
	ret

set_XXX4:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b10011000
	out PORTD, r19
	ret

set_XXX5:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b10110100
	out PORTD, r19
	ret

set_XXX6:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b11110100
	out PORTD, r19
	ret

set_XXX7:
	ldi r18, 0b00011100
	out PORTB, r18
	ldi r19, 0b00011100
	out PORTD, r19
	ret

set_XXX8:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret

set_XXX9:
	ldi r18, 0b00011101
	out PORTB, r18
	ldi r19, 0b10111100
	out PORTD, r19
	ret

set_XXX0:
	ldi r18, 0b00011100
	out PORTB, r18
	ldi r19, 0b11111100
	out PORTD, r19
	ret