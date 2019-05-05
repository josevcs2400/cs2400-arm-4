			;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
			;
			;		Write a subroutine that encodes 11 bits of data into a 15-bit
			;		block, using 4 parity bits. Assume even parity, that is,
			;		the parity of the bits covered by a parity bit, including
			;		the parity bit, has to be an even number. Assume the bits are
			;		written in the following sequence:
			;		p1, p2, d1, p4, d2, d3, d4, p8, d5, d6, d7, d8, d9, d10, d11, p16, d12, d13, d14
			;		Call the subroutine `hencode`.
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
			adr		r0, data
			ldr		r0, [r0]		;get address pointer of r0 and store that value in r0
			mov		r1, r0		;move r1 to r0, creates copy of r1
			mov		r2, #0		;r2 will be used for formatted 15 bits
			mov		r9, #0		;counter for number of 1's in value
			
			;		format to 15 bits and with 1's for parity bits
			and		r2, r1, #127	;logical & to get bits d5-d11
			add		r2, r2, #128	;add 0b10000000 to add p8
			lsr		r3, r1, #7	;logical shift right to get d1-d4
			eor		r3, r3, #8	;exlusive or to 0b1000, switches d1 to 0
			and		r3, r3, #7	;logical & to get 1 bits for d2-d4
			lsl		r3, r3, #8	;logical shift left r3 by 8 bits
			add		r2, r3, r2	;add r3 to r2 to get bits d2-d11
			add		r2, r2, #2048	;add 0b100000000000 to add p4
			add		r2, r2, #28672 ;add 0b111000000000000 to r2 for digits p1-d1
			
hencode
			;		figure out p1 value using masks
			adr		r3, p1covmask
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r4, r3
countp1_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r4, r4, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r4		;move r1 into r0
			cmp		r3, #0		;compare r1 to 0
			bne		countp1_1s	;branch to countp1_1s if compare is not equal to 0
			
			;		check if counter is odd or even
			lsrs		r9, r9, #1	;logical shift right lsb to see if 1 or 0
			;		update p1 value
			eorcc	r2, r2, #16384 ;0b100000000000000
			;addcs	r9, r9, #1
			;andcs	r2, r2, #16384
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		figure out p2 value using masks
			adr		r3, p2covmask
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r4, r3
countp2_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r4, r4, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r4		;move r1 into r0
			cmp		r3, #0		;compare r1 to 0
			bne		countp2_1s	;branch to countp2_1s if compare is not equal to 0
			
			;		check if counter is odd or even
			lsrs		r9, r9, #1	;logical shift right lsb to see if 1 or 0
			;		update p2 value
			eorcc	r2, r2, #8192 	;0b10000000000000
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		figure out p4 value using masks
			adr		r3, p4covmask
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r4, r3
countp4_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r4, r4, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r4		;move r1 into r0
			cmp		r3, #0		;compare r1 to 0
			bne		countp4_1s	;branch to countp2_1s if compare is not equal to 0
			
			;		check if counter is odd or even
			lsrs		r9, r9, #1	;logical shift right lsb to see if 1 or 0
			;		update p2 value
			eorcc	r2, r2, #2048 	;0b100000000000
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;		figure out p8 value using masks
			adr		r3, p8covmask
			ldr		r3, [r3]
			and		r3, r1, r3
			mov		r4, r3
countp8_1s
			sub		r3, r3, #1	;subtract r0 - 1 and store in r0
			and		r4, r4, r3	;logical r1 & r0 and store in r1
			add		r9, r9, #1	;increment counter
			mov		r3, r4		;move r1 into r0
			cmp		r3, #0		;compare r1 to 0
			bne		countp8_1s	;branch to countp2_1s if compare is not equal to 0
			
			;		check if counter is odd or even
			lsrs		r9, r9, #1	;logical shift right lsb to see if 1 or 0
			;		update p2 value
			eorcc	r2, r2, #128 	;0b10000000
			
			mov		r9, #0		;move 0 into r9, resets counter
			
			;=========================================
			;		converted value in r2
			;=========================================
			end
			
			;		0b--1-010-0100101
data			dcd		0b10100100101
			;		0b101101010100101
			
p1covmask		dcd		0b11011010101	;check 1, 2, 4, 5, 7, 9, 11 data bits
p2covmask		dcd		0b10110110011	;check 1, 3, 4, 6, 7, 10, 11 data bits
p4covmask		dcd		0b01110001111	;check 2, 3, 4, 8, 9, 10, 11 data bits
p8covmask		dcd		0b00001111111	;check 5, 6, 7, 8, 9, 10, 11 data bits
