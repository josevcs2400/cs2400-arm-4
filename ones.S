		;		ARM Programming Assignment #4: Count the ones in a binary number
		;
		;		Write a program that counts the number of ones in a binary number,
		;		stored in a word (4 bytes). Its loop should run no more times than there
		;		are ones in the number. Write the count in `numones`. For the example
		;		number given below, the loop should only run 8 times, counting 8 ones.
		;
		;		Hint:
		;		The first significant instruction in the loop is SUB r1, r1, 1, which
		;		decrements the number, assuming it's stored in register r1. Now,
		;		remember your logical operations.
		;
		;		Bonus:
		;		1. (20 extra points) For the shortest program (by instruction count),
		;		because this operation has to be FAST.
		;		2. (30 extra points) For extending the program to counting the ones
		;		in any word-aligned contiguous region of memory.
		
		;		Your code here
		adr		r1, example
		ldr		r1, [r1]
		mov		r2, r1		;create a copy of r1
loop
		sub		r1, r1, #1	;subtract r1 - 1 and store in r1
		and		r2, r2, r1	;logical r2 & r1 and store in r2
		add		r3, r3, #1	;increment counter
		mov		r1, r2		;move r2 into r1
		cmp		r1, #0		;compare r1 to 0
		bne		loop			;branch to loop if compare is not equal to 0
		adr		r0, numones	;get address of numones and store in r0
		str		r3, [r0]		;store counter in numones, last line no "end" needed
example	DCD		0x0010070f	;0b100000000011100001111
numones	FILL		4
