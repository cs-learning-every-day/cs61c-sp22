.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
	li t0 1
	bge a1 t0 loop_start
	li a0 36
	j exit
loop_start:
	li t0 1 # i
	li t1 0 # res_idx
	lw t2 0(a0) # res_elem
loop_continue:
	bge t0 a1 loop_end
	# t4 = a[i]
	slli t3 t0 2
	add t3 a0 t3
	lw t4 0(t3)
	ble t4 t2 skip 
	# update result
	add t1 zero t0
	add t2 zero t4
skip:
	addi t0 t0 1
	j loop_continue
loop_end:
	# Epilogue
	add a0 zero t1
	ret
