			;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
			;
			;		Write a subroutine that decodes a H(15, 11) block to extract
			;		the 11 data bits. Call it `hdecode`. It should:
			;		- calculate the correcting code
			;		- dentify the case: no error (noer), one-bit error (onee)
			;		- write the result in `case` using the encoding provided
			;		- if there is a one-bit error, write the number of the
			;		erroneous bit in `berr`
			;		- if there is a one-bit error, correct the data
			;		- write the result in `corr`
			;
			;		Now, write a main function which uses `hencode` and `decode`
			;		to encode `data` and then, after a simulated transmission,
			;		decode `recv`. Assume that `recv` contains what is received
			;		at the other end.
			
			;		Your code here
			
main
			;hdecode
			adr		r0, recv
			ldr		r0, [r0]
			mov		r1, r0		;move r0 into r1, makes a copy of r0
			
			;get		values for parity bits
			;r4		= p1
			;r5		= p2
			;r6		= p4
			;r7		= p8
			lsr		r4, r1, #14	;p1
			mov		r5, #0		;p2
			lsr		r8, r1, #13
			lsrs		r8, r8, #1
			addcs	r5, r5, #1
			mov		r6, #0		;p4
			lsr		r8, r1, #11
			lsrs		r8, r8, #1
			addcs	r6, r6, #1
			mov		r7, #0		;p8
			lsr		r8, r1, #7
			lsrs		r8, r8, #1
			addcs	r7, r7, #1
			
			;count	data bits
			
			;		check p1 using masks
			adr		r3, p1decode
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r11, r3
countp1_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r11, r11, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r11		;
			cmp		r3, #0		;compare r1 to 0
			bne		countp1_1s	;branch to count1_1s if compare is not equal to 0
			mov		r10, #0
			lsrs		r8, r9, #1
			movcs	r4, #31
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		check p2 using masks
			adr		r3, p2decode
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r11, r3
countp2_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r11, r11, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r11		;
			cmp		r3, #0		;compare r1 to 0
			bne		countp2_1s	;branch to count1_1s if compare is not equal to 0
			mov		r10, #0
			lsrs		r8, r9, #1
			movcs	r5, #31
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		check p4 using masks
			adr		r3, p4decode
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r11, r3
countp4_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r11, r11, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r11		;
			cmp		r3, #0		;compare r1 to 0
			bne		countp4_1s	;branch to count1_1s if compare is not equal to 0
			mov		r10, #0
			lsrs		r8, r9, #1
			movcs	r6, #31
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		check p8 using masks
			adr		r3, p8decode
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r11, r3
countp8_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r11, r11, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r11		;
			cmp		r3, #0		;compare r1 to 0
			bne		countp8_1s	;branch to count1_1s if compare is not equal to 0
			mov		r10, #0
			lsrs		r8, r9, #1		;if cmp not equal 0, error found, mark r7 as 0b1111
			movcs	r7, #31
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		add	each error parity bit with errors to find erroneous bit location
			mov		r2, #0		;reset r2 to #0
			mov		r3, #0
			eor		r3, r4, #31
			cmp		r3, #0
			addeq	r2, r2, #1
			mov		r3, #0
			eor		r3, r5, #31
			cmp		r3, #0
			addeq	r2, r2, #2
			mov		r3, #0
			eor		r3, r6, #31
			cmp		r3, #0
			addeq	r2, r2, #4
			mov		r3, #0
			eor		r3, r7, #31
			cmp		r3, #0
			addeq	r2, r2, #8
			adr		r3, berr
			str		r2, [r3]		;if there is an error write bit number in 'berr'
			
			;if		there is a one-bit error, correct the data
			mov		r11, #1
			mov		r3, #0
			mov		r4, #15
			sub		r3, r4, r2
			lsl		r11, r11, r3
			eor		r3, r1, r11
			adr		r4, corr
			str		r3, [r4]
			
			;identify	the case: no error or one-bit error
			adr		r3, case
			adr		r4, noer
			adr		r5, onee
			ldr		r4, [r4]
			ldr		r5, [r5]
			str		r4, [r3]		;store noer 0x00 in [r3] if no errors
			cmp		r2, #1
			strne	r5, [r3]		;store onee 0x01 in [r3] if one-bit error
			
			end
			
			;		0b--1-010-0100101
recv			dcd		0b101111010100101
			;		0b10100100101 error found d2
			
p1decode		dcd		0b101010101010101
p2decode		dcd		0b011001100110011
p4decode		dcd		0b000111100001111
p8decode		dcd		0b000000011111111
			
noer			DCD		0x00
onee			DCD		0x01
			
case			FILL		4
berr			FILL		4
corr			FILL		4
