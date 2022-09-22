.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
	# Prologue
	li t0 1
	blt a2 t0 length_err
	blt a3 t0 stride_err
	blt a4 t0 stride_err
loop_start:
	# i, j
	li t0 0
	li t1 0
	# res
	li t2 0
	# use cnt
	li t6 0
loop_continue:
	bge t6 a2 loop_end
	slli t3 t0 2
	add t3 a0 t3
	slli t4 t1 2
	add t4 a1 t4
	lw t3 0(t3)
	lw t4 0(t4)
	# res += a0[t0] * a1[t1]
	mul t5 t4 t3
	add t2 t2 t5

	add t0 t0 a3
	add t1 t1 a4
	addi t6 t6 1
	j loop_continue
loop_end:
	# Epilogue
	add a0 zero t2
	ret

length_err:
	li a0 36
	j exit
stride_err:
	li a0 37
	j exit