;; Authors: Chris Randall and Mark Donohue

;; This program computes the factorial of a number
;; and then divides the number by 5 to obtain the
;; quotient and the remainder

.ORIG x3000

;; Main program register usage:
; R1 = NUMBER
; R6 = stack pointer

;; Main program pseudocode:

; number = factorial(number)
; quotient = number // 5
; remainder = number % 5

; Main rogram code
	LD R6, STACKBOTTOM; Initialize the stack pointer
	LEA R1, ARRAY
	LD R2, SIZE
	LEA R0, MESSAGE
	PUTS
	JSR GETS
	JSR INT
	ADD R1, R2, #0
	ST R2, ORIGNUMBER
	JSR FACTORIAL
	ST R1, FACT
	LEA R0, MESSAGE2
	PUTS
	LEA R1, NUMARRAY
	LD R2, ORIGNUMBER
	JSR TOSTRING
	ADD R0, R1, #0
	PUTS
	LEA R0, MESSAGE3
	PUTS
	LEA R1, FACTARRAY
	LD R2, FACT
	JSR TOSTRING
	ADD R0, R1, #0
	PUTS
	HALT

; Main program data variables
ARRAY		.BLKW 32
SIZE		.BLKW 30
NUMARRAY	.BLKW 5
FACTARRAY	.BLKW 15
ORIGNUMBER	.BLKW 1
FACT		.BLKW 1
QUOTIENT	.BLKW 1
DIVISOR		.FILL 5
REMAINDER	.BLKW 1
STACKBOTTOM	.FILL xFDFF; Address of the bottom of the stack
MESSAGE		.STRINGZ "Enter a number: "
MESSAGE2	.STRINGZ "The factorial of "
MESSAGE3	.STRINGZ " is "


;; Subroutine FACTORIAL
;  Returns the factorial of R1 in R1
;  Input parameter: R1 (the number)
;  Output parameter: R1 (the number)
;  Working storage: R2 and R3

; Pseudocode:

; product = 1
; while n > 0
;    product *= n
;    n -= 1

FACTORIAL	ADD R0, R7, #0; Save registers
		JSR PUSH
           	ADD R0, R3, #0
		JSR PUSH
           	ADD R0, R2, #0
		JSR PUSH
		LD R2, FACTONE; Initialize the product to 1
FACTLOOP	JSR MUL; R3 = R1 * R2
		ADD R2, R3, #0; Shift the product back to R2
		ADD R1, R1, #-1; Decrement the number
		BRp FACTLOOP
		ADD R1, R2, #0; Shift product for return
		JSR POP; Restore registers
		ADD R2, R0, #0
		JSR POP; Restore registers
		ADD R3, R0, #0
		JSR POP
		ADD R7, R0, #0
		RET

; Data for subroutine FACTORIAL
FACTONE		.FILL #1


;; Subroutine MUL
;  Multiplies R1 by R2 and stores result in R3
;  R3 = R1 * R2
;  Input parameters: R1 and R2, both non-negative
;  Output parameter: R3

;; Pseudocode design:

; sum = 0
; while first > 0
;	sum += second
;	first -= 1
; return sum

MUL	ADD R0, R7, #0; Save registers
	JSR PUSH
	ADD R0, R1, #0        
	JSR PUSH
	AND R3, R3, #0; Initialize sum for accumulation
        ADD R1, R1, #0  ; if first or second is 0, quit
        BRz ENDMUL
        ADD R2, R2, #0
        BRz ENDMUL
MULLOOP	ADD R3, R3, R2; sum += second
	ADD R1, R1, #-1; first -= 1
	BRp MULLOOP; Exit when first == 0
ENDMUL	JSR POP; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R7, R0, #0

	RET


;; Subroutine DIV
;  Divides R1 by R2 and stores quotient in R3 and remainder in R4
;  R3 = R1 // R2, R4 = R1 % R2
;  Input parameters: R1 (dividend) and R2 (divisor), both positive integers
;  Output parameters: R3 (quotient) and R4 (remainder)

; Pseudocode:

; quotient = 0
; while (dividend - divisor) >= 0
;     dividend -= divisor
;     quotient += 1
; remainder = dividend

DIV	ADD R0, R7, #0; Save registers
	JSR PUSH
	ADD R0, R2, #0        
	JSR PUSH
	ADD R0, R1, #0
        JSR PUSH
	NOT R2, R2; Negate the divisor
	ADD R2, R2, #1  
	AND R3, R3, #0; Initialize the quotient (a counter)
DIVLOOP	ADD R4, R1, R2; Entry test for the division loop (dividend - divisor >= 0)
	BRn ENDDIV
	ADD R1, R1, R2; dividend -= divisor
	ADD R3, R3, #1; quotient += 1
	BR DIVLOOP; Return to the top of the loop
ENDDIV	ADD R4, R1, #0; Set the remainder to dividend for return
	JSR POP; Restore registers
	ADD R1, R0, #0
	JSR POP
	ADD R2, R0, #0
	JSR POP
	ADD R7, R0, #0
	RET

;; Subroutine TOSTRING
;  Converts the integer in R2 to a string with base address R1
;  Input parameters: R1 = base address of string buffer
;                    R2 = an integer
;  Output parameter: R1 = base address of the string buffer

TOSTRING	ST R1, STRBASE; Save return address, parameters, and temporaries
 		ADD R0, R7, #0
		JSR PUSH
 		ADD R0, R4, #0
		JSR PUSH
 		ADD R0, R3, #0
		JSR PUSH
 		ADD R0, R2, #0
		JSR PUSH
 		AND R0, R0, #0; Push the null character onto the stack
 		JSR PUSH
           	ADD R1, R2, #0; Set the initial dividend
STRLOOP 	LD R2, INT10; Divide the number by 10
 		JSR DIV
 		LD R2, CHRZERO; Convert the remainder and push it
 		ADD R0, R4, R2; onto the stack
           	JSR PUSH 
 		ADD R1, R3, #0; Set the dividend to the quotient
		BRp STRLOOP; While quotient > 0

 		LD R1, STRBASE; Move characters from the stack to the
POPLOOP 	JSR POP; string buffer, stopping after the null
 		STR R0, R1, #0; character is moved
 		ADD R0, R0, #0
 		BRz ENDPOP
 		ADD R1, R1, #1
           	BR POPLOOP

ENDPOP 		LD R1, STRBASE; Restore all registers
		JSR POP
		ADD R2, R0, #0
		JSR POP
		ADD R3, R0, #0
		JSR POP
		ADD R4, R0, #0
		JSR POP
		ADD R7, R0, #0
 		RET

; Subroutine TOSTRING data variables (also uses INT10 from INT)
CHRZERO .FILL   #48; ASCII for the digit '0'
STRBASE .BLKW  1; Base address of string buffer for the sum


;; Subroutine INT
;  Input parameter:  R1 - the address of the string buffer
;  Output parameter: R2 - the integer represented by the string

;  Register usage:
;  R3 = temporary working storage
;  R4 = the pointer into the string buffer

INT	AND 	R2, R2, #0
	ADD R0, R7, #0
	JSR PUSH
	ADD R0, R1, #0
	JSR PUSH
	ADD R0, R3, #0
	JSR PUSH
	ADD R0, R4, #0
	JSR PUSH
	AND R3, R3, #0; Clear the sum
	ST R3, INTSUM
	ADD R4, R1, #0; Set the pointer into the buffer
INTLOOP	LDR R1, R4, #0; Get the next digit from the buffer
	BRz ENDINT; Quit when it's nul
	LD R2, ORDZERO; Convert the digit to an int
	ADD R1, R1, R2
	ST R1, INTDIGIT
	LD R1, INTSUM; Multiply the sum by 10
	LD R2, INT10
	JSR MUL
	LD R1, INTDIGIT; Add int value of digit to the sum
	ADD R3, R3, R1
	ST R3, INTSUM
	ADD R4, R4, #1; Advance to the next character in the buffer
	BR INTLOOP
ENDINT	LD R2, INTSUM; Set the output parameter
	JSR POP
	ADD R4, R0, #0
	JSR POP
	ADD R3, R0, #0
	JSR POP
	ADD R1, R0, #0
	JSR POP
	ADD R7, R0, #0
; Restore registers
RET

; Subroutine INT data variables
INTDIGIT	.BLKW   1; Holds the integer value of each digit
ORDZERO 	.FILL   #-48          ; ASCII for the digit '0' (negated)
INT10 		.FILL  #10; Base of 10
INTSUM 		.FILL  #0; Holds the running total for the sum

;; Subroutine GETS
; Gets a string of characters
; Input Parameters: R1 = base address of the string
; R2 = maximum size of array
; R3 and R4 are working storage

GETS	ADD	R0, R7, #0
	JSR 	PUSH
	ADD 	R0, R1, #0
	JSR 	PUSH
	ADD 	R0, R2, #0
	JSR 	PUSH
	ADD 	R0, R3, #0
	JSR 	PUSH
	ADD 	R0, R4, #0
	JSR 	PUSH
	WHILE	GETC; Read and echo character
	OUT
	AND	R4, R4, #0; Resets test
	ADD	R4, R0, #-10; Checks for character
	BRz	ENDWHILE
	AND	R4, R4, #0; Resets test
	ADD	R4, R0, #-13; Checks for character
	BRz	ENDWHILE
	STR	R0, R1, #0; Store character in array
	ADD	R1, R1, #1; Increment address
	ADD	R2, R2, #-1; Decrement size
	BR 	WHILE; Return to read another

ENDWHILE	AND R4, R4, #0
		STR R4, R1, #0; Store null character
		JSR POP
		ADD R4, R0, #0
		JSR POP
		ADD R3, R0, #0
		JSR POP
		ADD R2, R0, #0
		JSR POP
		ADD R1, R0, #0
		JSR POP
		ADD R7, R0, #0
		RET

;; Runtime stack management

;; Subroutine PUSH
;  Copies R0 to the top of the stack and decrements the stack pointer
;  Input parameters: R0 (the datum) and R6 (the stack pointer)
;  Output parameter: R6 (the stack pointer)
PUSH	ADD R6, R6, #-1
	STR R0, R6, #0
	RET

;; Subroutine POP
;  Copies the top of the stack to R0 and increments the stack pointer
;  Input parameter: R6 (the stack pointer)
;  Output parameters: R0 (the datum) R6 (the stack pointer)
POP	LDR 	R0, R6, #0
	ADD R6, R6, #1
	RET
.END