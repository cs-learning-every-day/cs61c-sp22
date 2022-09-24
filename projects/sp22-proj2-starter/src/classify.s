.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	li t0 5
	bne a0 t0 invalid_arg_cnt_err
	# Prologue
	addi sp sp -52
	sw s0 0(sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw s6 24(sp)
	sw s7 28(sp)
	sw s8 32(sp)
	sw s9 36(sp)
	sw s10 40(sp)
	sw s11 44(sp)
	sw ra 48(sp)

	mv s1 a1
	mv s2 a2

	# Read pretrained m0
	# malloc row/col 
	# s3 s4
	li a0 4
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s3 a0

	li a0 4
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s4 a0

	# matrix pointer
	# s5: m0 row: s8 col: s9 value
	# s6: m1 row: s0 col: s10 value 
	# s7: input row: s3 col: s4 pointer
	addi t0 s1 4
	lw t0 0(t0)
	mv a0 t0
	mv a1 s3
	mv a2 s4
	jal read_matrix
	mv s5 a0
	lw s8 0(s3)
	lw s9 0(s4)
	
	# Read pretrained m1
	addi t0 s1 8
	lw t0 0(t0)
	mv a0 t0
	mv a1 s3
	mv a2 s4
	jal read_matrix
	mv s6 a0
	lw s0 0(s3)
	lw s10 0(s4)
	# Read input matrix
	addi t0 s1 12
	lw t0 0(t0)
	mv a0 t0
	mv a1 s3
	mv a2 s4
	jal read_matrix
	mv s7 a0
	# Compute h = matmul(m0, input)
	# s11: malloc c for h (row/col :s8/*s4)
	lw t1 0(s4)
	mul t0 s8 t1
	slli t0 t0 2
	mv a0 t0
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s11 a0

	mv a0 s5
	mv a1 s8
	mv a2 s9
	mv a3 s7
	lw a4 0(s3)
	lw a5 0(s4)
	mv a6 s11
	jal matmul
	# Compute h = relu(h)
	lw t1 0(s4)
	mul t0 s8 t1
	mv a1 t0
	mv a0 s11
	jal relu
	# Compute o = matmul(m1, h)
	# s5= &o   row/col: s0/*s4
	lw t1 0(s4)
	mul t0 s0 t1
	slli t0 t0 2
	mv a0 t0
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s5 a0

	mv a0 s6
	mv a1 s0
	mv a2 s10
	mv a3 s11
	mv a4 s8
	lw a5 0(s4)
	mv a6 s5
	jal matmul
	# Write output matrix o
	addi t0 s1 16
	lw a0 0(t0)
	mv a1 s5
	mv a2 s0
	lw a3 0(s4)
	jal write_matrix
	# Compute and return argmax(o)
	mv a0 s5
	lw t0 0(s4)
	mul t0 s0 t0
	mv a1 t0
	jal argmax
	mv s0 a0

	# If enabled, print argmax(o) and newline	
	li t0 0
	bne s2 t0 end
	jal print_int
	li a0 '\n'
	jal print_char
end:
	mv a0 s3
	jal free

	mv a0 s4
	jal free
	
	# 这里s5已经被o替换了所以free(*(s1+4))
	addi t0 s1 4
	lw a0 0(t0)
	jal free

	mv a0 s5
	jal free
	
	mv a0 s6
	jal free

	mv a0 s7
	jal free

	mv a0 s11
	jal free

	mv t1 s0
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
	lw s9 36(sp)
	lw s10 40(sp)
	lw s11 44(sp)
	lw ra 48(sp)
	addi sp sp 52 
	mv a0 t1
	ret
malloc_err:
	li a0 26
	j exit
invalid_arg_cnt_err:
	li a0 31
	j exit