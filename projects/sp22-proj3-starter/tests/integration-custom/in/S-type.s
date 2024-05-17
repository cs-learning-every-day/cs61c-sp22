addi s1, x0, 256

addi sp, sp, -12
sw s1, 0(sp)
sh s1, 4(sp)
sb s1, 8(sp)

lw t0, 0(sp)
lh t1, 0(sp)
lb t2, 0(sp)