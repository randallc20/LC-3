;Chris Randal
;In my original code I used the wrong storage and I forgot to store the final value
;The new code inverts the correct space in memory and stores the value in R1 
.ORIG x3000
;Program Code
	LD R0, NUMBER	; Load NUMBER
	NOT R0, R0
	ADD R1, R1, #1	; Invert Second Value ; I inverted the wrong space in memory
	ST R1, NUMBER	; I needed to use this line to store the value
HALT
; Main
NUMBER	.FILL #55