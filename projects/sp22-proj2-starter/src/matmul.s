.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
	# Error checks
	li t0 1
	# m * n    n * p = m * p
	blt a1 t0 length_err
	blt a2 t0 length_err
	blt a4 t0 length_err
	blt a5 t0 length_err
	bne a2 a4 length_err
	# Prologue
	addi sp sp -40
	sw s0 0(sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw s6 24(sp)
	sw s7 28(sp)
	sw s8 32(sp)
	sw ra 36(sp)

	# save argument  later call dot function
	#  A B C
	mv s0 a0
	mv s1 a3
	mv s2 a6

	# m p n
	mv s3 a1
	mv s4 a5
	mv s5 a2
	# row col
	li s6 0
	li s7 0

	# C[row][col] = dot(A[row], B[col])
outer_loop_start:
	bge s6 s3 outer_loop_end
	# potin to s6th row of A
	mul s8 s5 s6
	slli s8 s8 2
	add s8 s8 s0
inner_loop_start:
	bge s7 s4 inner_loop_end
	# point to s7th col of B
	slli t3 s7 2
	add t3 t3 s1


	mv a0 s8
	mv a1 t3
	mv a2 s5
	li a3 1
	mv a4 s4
	jal dot
	# save result
	mul t0 s6 s4
	add t0 t0 s7
	slli t0 t0 2
	add t0 t0 s2
	ebreak
	sw a0 0(t0)

	addi s7 s7 1
	j inner_loop_start
inner_loop_end:
	li s7 0
	addi s6 s6 1
	j outer_loop_start
outer_loop_end:
	# Epilogue
	lw s0 0(sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	lw s4 16(sp)
	lw s5 20(sp)
	lw s6 24(sp)
	lw s7 28(sp)
	lw s8 32(sp)
	lw ra 36(sp)
	addi sp sp 40
	ret

length_err:
	li a0 38
	j exit
