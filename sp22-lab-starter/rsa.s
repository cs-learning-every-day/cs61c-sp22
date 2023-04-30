#
# CMPUT 229 Student Submission License
# Version 1.0
#
# Copyright 2019 <student name>
#
# Redistribution is forbidden in all circumstances. Use of this
# software without explicit authorization from the author or CMPUT 229
# Teaching Staff is prohibited.
#
# This software was produced as a solution for an assignment in the course
# CMPUT 229 - Computer Organization and Architecture I at the University of
# Alberta, Canada. This solution is confidential and remains confidential 
# after it is submitted for grading.
#
# Copying any part of this solution without including this copyright notice
# is illegal.
#
# If any portion of this software is included in a solution submitted for
# grading at an educational institution, the submitter will be subject to
# the sanctions for plagiarism at that institution.
#
# If this software is found in any public website or public repository, the
# person finding it is kindly requested to immediately report, including 
# the URL or other repository locating information, to the following email
# address:
#
#          cmput229@ualberta.ca
#
#---------------------------------------------------------------
# CCID:                 
# Lecture Section:      
# Instructor:           J. Nelson Amaral
# Lab Section:          
# Teaching Assistant:   
#---------------------------------------------------------------
# 

.include "common.s"

#----------------------------------
#        STUDENT SOLUTION
#----------------------------------
  .data
string: .string "(a(b(c)))(b)"
result: .space 100

.text
rsa:
  # remove parentheses and print alpha characters
  addi x8, x0, 0 # initialize index for result string
  addi x9, x0, 0 # initialize index for input string
  addi x10, x0, 0 # initialize stack index

loop:
  lb   x11, string(x9) # load current character
  beq  x11, x0, done   # if null, exit loop
  addi x9, x9, 1       # increment input string index
  beq  x11, '(', open_paren
  beq  x11, ')', close_paren
  bne  x11, x0, alpha
  j    loop

open_paren:
  addi x10, x10, 1 # increment stack index
  sb   x9, result(x10) # store input string index on the stack
  j    loop

close_paren:
  beq  x10, x0, loop # if stack is empty, ignore and continue
  addi x10, x10, -1 # decrement stack index
  lb   x11, result(x10) # load input string index from the stack
  addi x11, x11, 1 # increment input string index
  lb   x12, string(x11) # load next character
  bne  x12, x0, alpha   # if not null, it's an alpha char
  j    loop

alpha:
  sb   x11, result(x8)  # store alpha character in result string
  addi x8, x8, 1        # increment result string index
  j    loop

done:
  # print result
  addi x10, x0, 4
  ecall
