;Chris Randall
;In my original code I did not successfully run through the array
;Furthermore, I did not not set up a base address for the array
;I basically ran out of time and only made incorrect registers, and 
;attempted to iterate through an array.
;The new code has correct registers, and loads in the base register 
;then loops through the entire array using the while loop until it reaches the breakout condition
.ORIG x3000
; Register usage:
; R0 = N
; R1 = base address of ARRAY
; R2 = X
; Program code:
      LD R0, N
      LEA R1, ARRAY
      AND R2, R2, #0
      ADD R2, R2, #1          ; X = 1
WHILE STR R2, R1, #0           ; ARRAY[X - 1] = X
      ADD R1, R1, #1
      ADD R2, R2, #1          ; X = X + 1
      ADD R0, R0, #-1         ; N = N - 1
      BRp WHILE               ; Exit loop if N = 0
	HALT

;Program Data
N	.FILL	#7
ARRAY	.BLKW	#7

.END