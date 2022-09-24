.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
	# Prologue
	addi sp sp -28
	sw s0 0(sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw ra 24(sp)

	# save argument
	mv s1 a1
	mv s2 a2
	mv s3 a3
	mul s0 a2 a3

	# open file
	# s5: file fd
	li a1 1
	jal fopen
	li t0 -1
	beq a0 t0 fopen_err
	mv s5 a0

	# s4: malloc 4 bytes for row/col
	li a0 4
	jal malloc
	li t0 0
	beq a0 t0 malloc_err
	mv s4 a0

	# write row/col
	sw s2 0(s4)
	mv a0 s5
	mv a1 s4
	li a2 1
	li a3 4
	jal fwrite
	li t0 1
	bne a0 t0 fwrite_err

	sw s3 0(s4)
	mv a0 s5
	mv a1 s4
	li a2 1
	li a3 4
	jal fwrite
	li t0 1
	bne a0 t0 fwrite_err

	# write matrix
	mv a0 s5
	mv a1 s1
	mv a2 s0
	li a3 4
	ebreak
	jal fwrite
	bne a0 s0 fwrite_err

	# close file
	mv a0 s5
	jal fclose
	li t0 0
	bne a0 t0 fclose_err

	# Epilogue
	lw s0 0(sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	lw s4 16(sp)
	lw s5 20(sp)
	lw ra 24(sp)
	addi sp sp 28
	ret
fopen_err:
	li a0 27
	j exit
fclose_err:
	li a0 28
	j exit
fwrite_err:
	li a0 30
	j exit
malloc_err:
	li a0 26
	j exit