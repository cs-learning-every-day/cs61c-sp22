.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue
	addi sp sp -28
	sw s0 0(sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw ra 24(sp)

	# row/col pointer
	add s1 zero a1
	add s2 zero a2


	# s0: file fd
	li a1 0
	jal fopen
	li t0 -1
	beq a0 t0 fopen_err
	add s0 zero a0

	# read row col
	add a1 zero s1
	li a2 4
	jal fread
	li t0 4
	bne a0 t0 fread_err

	mv a0 s0
	add a1 zero s2
	li a2 4
	jal fread
	li t0 4
	bne a0 t0 fread_err

	# malloc row * col * 4
	# s3 = result pointer
	# s5 = row * col
	lw t0 0(s1)
	lw t1 0(s2)
	mul t0 t0 t1
	mv s5 t0
	slli t0 t0 2
	mv a0 t0
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s3 a0

	# i = 0 loop i < row * col
	li s4 0 
loop:
	bge s4 s5 end
	# cur pointer
	slli t0 s4 2
	add t0 t0 s3

	mv a0 s0
	add a1 zero t0
	li a2 4
	jal fread
	li t0 4
	bne a0 t0 fread_err

	addi s4 s4 1
	j loop
end:
	mv a0 s0
	jal fclose
	li t0 0
	bne a0 t0 fclose_err

	# Epilogue
	mv a0 s3

	lw s0 0(sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	lw s4 16(sp)
	lw s5 20(sp)
	lw ra 24(sp)
	addi sp sp 28

	ret

malloc_err:
	li a0 26
	j exit
fopen_err:
	li a0 27
	j exit
fclose_err:
	li a0 28
	j exit
fread_err:
	li a0 29
	j exit