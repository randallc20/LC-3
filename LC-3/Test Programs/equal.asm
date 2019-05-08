;Chris Randall
.ORIG x3000
;Original did not work because I tried to use EQUAL as a lable and a data location
;Also I subtracted incorrectly, and I tired to make the program more complicated
;I tried to have three values of negative, positive, and equal
;I needed to only test if they were not equal or positive after subtraction
;Thus determining what the value of A - B would be

; Register usage:
; R1 = A
; R2 = B
; R3 = A - B
; R4 the Boolean result of ==
     LD R1, A
     LD R2, B
     AND R4, R4, #0    ; False by default
     NOT R3, R2        ; Subtract B from A
     ADD R3, R3, #1
     ADD R3, R3, R1
     BRnp DONE         ; Branch if not equal
     ADD R4, R4, #1    ; Reset to True
DONE ST R4, EQUAL
	HALT

;Main Program Data
A	.FILL	#4
B	.FILL	#4
EQUAL	.FILL	#0
.END