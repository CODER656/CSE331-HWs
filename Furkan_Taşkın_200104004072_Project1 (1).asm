.data
size: .word 16
matrix1: .space 256
matrix2: .space 256
newline: .asciiz "\n"
prompt: .asciiz "\nEnter a character: "
youEntered: .asciiz "\n You entered: \n"
afterDet: .asciiz "\n After Detonating: \n"
afterFill: .asciiz "\n After Filling matrix2: \n"


		.text
main:
    # Add stack management instructions
    sub $sp, $sp, 12

    la $a0, matrix1
    jal inputMatrix   # inputMatrix(matrix1);
    
    # printing Str1
    la $a0, youEntered
    li $v0, 4
    syscall
    
    la $a1, matrix1
    jal print		# print(matrix1);
    
    la $a0, matrix2	# fill(matrix2);
    jal fill
    
    #after filling message
    la $a0, afterFill
    li $v0, 4
    syscall
    
    la $a1, matrix2
    jal print		# print(matrix2);
    
    
    la $a0, matrix1
    la $a1, matrix2
    jal detonate_bomb
    
    #printing newline
    la $a0, newline
    li $v0, 11
    syscall
    
    # printing after detonating message
    la $a0, afterDet
    li $v0, 4
    syscall
    
    la $a1, matrix2
    jal print		# print(matrix2);

    # Restore stack pointer
    add $sp, $sp, 12
    
    # Exit the program
    li $v0, 10         # System call code for exit
    syscall






#-------------------------------------------------------------------------
#			InputMatrix function    


# InputMatrix function
inputMatrix:
    la $t0, matrix1    # Load the base address of the matrix into $t0
    lw $t1, size       # Load the size of the matrix into $t1
    li $t2, 0          # Initialize row index to 0

    # Outer loop for rows
outer_loop:
    beq $t2, $t1, endloop1_1  # If row index equals matrix size, exit outer loop

    li $t3, 0               # Initialize column index to 0

    # Inner loop for columns
inner_loop:
    beq $t3, $t1, end_inner_loop  # If column index equals matrix size, exit inner loop

    la $a0, prompt         # Load the address of the prompt
    li $v0, 4              # System call code for print_str
    syscall

    li $v0, 12             # System call code for read_char
    syscall
    sb $v0, 0($t0)         # Store the character in the matrix
    addi $t0, $t0, 1       # Move to the next element in the matrix
    addi $t3, $t3, 1       # Increment the column index
    j inner_loop           # Jump back to the inner loop

end_inner_loop:
    addi $t2, $t2, 1       # Increment the row index
    j outer_loop           # Jump back to the outer loop

endloop1_1:
    jr $ra                # Return from the function
    
    
 
 
 
#-------------------------------------------------------------------------
#			fill function    
    
  
fill:
    # $a0 is the base address of the array
    # $t1 is the size of the array
    # $t2 and $t3 are the loop counters
    lw $t1, size # t1 = size
    li $t2, 0 # i = 0

# Outer loop for rows
loop1:
    beq $t2, $t1, endloop1 # i < size
    li $t3, 0 # j = 0

    # Inner loop for columns
    loop2:
        beq $t3, $t1, endloop2
        mul $t5, $t2, $t1    # $t5 = i * size (size of each row in bytes)
        add $t5, $t5, $t3  # $t5 = i * size + j
        add $t4, $a0, $t5  # $t4 = base address of array + offset
        li $t5, '0'
        sb $t5, 0($t4)
        addi $t3, $t3, 1
        j loop2
    endloop2:
    addi $t2, $t2, 1
    j loop1
endloop1:
    jr $ra   
    



#-------------------------------------------------------------------------
#			print function    

# print function
print:
    # $a0 is the base address of the array
    # $t1 is the size of the array
    # $t2 and $t3 are the loop counters
    lw $t1, size
    li $t2, 0 # row counter

    # Outer loop for rows
print_loop1:
    beq $t2, $t1, print_endloop1  # If we've reached the end of the rows, jump to endloop1
    li $t3, 0 #column counter

    # Inner loop for columns
    print_loop2:
        
        beq $t3, $t1, print_endloop2  # If we've reached the end of the columns, jump to endloop2
	
	li $v0, 11              # System call number for print_char
        lb $a0, 0($a1)          # Load the byte at the calculated address into $a0
        syscall                 # Execute the system call
        
        addi $t3, $t3, 1        # Increment the column index
        addi $a1, $a1, 1	 #increment the adrress of matrix
        
        j print_loop2           # Jump back to the start of the inner loop
        
    print_endloop2:
    
    # Print a newline after each row
    li $v0, 4                 # System call number for print_str
    la $a0, newline           # Load the address of the newline string into $a0
    syscall                   # Execute the system call
    
    addi $t2, $t2, 1          # Increment the row index
    li $t3, 0		       # column counter to 0
    
    bne $t2, $t1, print_loop1
    
    j print_loop1                   # Jump back to the start of the outer loop
    
print_endloop1:
    jr $ra                    # Return from the function



#------------------------------------------------------------------------------
#			detonate function# detonate_bomb function
# detonate_bomb function
# Parameters:
#   $a0: base address of arr
#   $a1: base address of arr2
#   $a2: size
# detonate_bomb function
# $a0 is the base address of arr
# $a1 is the base address of arr2
# $t1 is the size of the array
# $t2 and $t3 are the loop counters

detonate_bomb:
    la $a0, matrix1       # Load the base address of matrix1 into $a0
    la $a1, matrix2       # Load the base address of matrix2 into $a1
    lw $t1, size          # Load the size of the array into $t1

    # Outer loop (i)
    li $t2, 0             # Initialize outer loop counter to 0
outer_loop_2:
    bge $t2, $t1, end_outer_loop  # If outer loop counter >= size, exit the outer loop

    # Inner loop (j)
    li $t3, 0             # Initialize inner loop counter to 0
inner_loop_2:
    bge $t3, $t1, end_inner_loop_2  # If inner loop counter >= size, exit the inner loop

    # Calculate offset for arr[i][j]
    mul $t4, $t2, $t1     # $t4 = i * size
    add $t4, $t4, $t3     # $t4 = i * size + j
    add $t5, $a0, $t4     # $t5 = base address of arr + offset

    # Check if arr[i][j] == '0'
    lb $t6, 0($t5)        # Load the byte at address $t5 into $t6
    li $t7, '0'           # Load ASCII value of '0' into $t7
    beq $t6, $t7, set_dot  # If arr[i][j] == '0', set arr2[i][j] = '.'

    # Continue to the next iteration
    j skip

set_dot:
    # Set arr2[i][j] = '.'
    add $t5, $a1, $t4     # $t5 = base address of arr2 + offset
    li $t6, '.'           # Load '.' into $t6
    sb $t6, 0($t5)        # Store the byte at address $t5 with the value in $t6

    # If i > 0, set arr2[i-1][j] = '.'
    bgtz $t2, set_above
    j skip_set_above
set_above:
    sub $t4, $t4, $t1     # $t4 = (i-1) * size + j
    add $t5, $a1, $t4     # $t5 = base address of arr2 + offset
    sb $t6, 0($t5)        # put the dot character
skip_set_above:

    # If i < size - 1, set arr2[i+1][j] = '.'
    addi $t7, $t2, 1  # i+1   
    blt $t7, $t1, set_below # i+1 < size
    j skip_set_below
set_below:
    add $t4, $t4, $t1     # $t4 = (i+1) * size + j
    add $t5, $a1, $t4     # $t5 = base address of arr2 + offset
    sb $t6, 0($t5)        # put dot to matrix
skip_set_below:

    # If j > 0, set arr2[i][j-1] = '.'
    bgtz $t3, set_left
    j skip_set_left
set_left:
    sub $t5, $t4, 1       # $t5 = i * size + (j-1)
    add $t5, $a1, $t5     # $t5 = base address of arr2 + offset
    sb $t6, 0($t5)        # put dot to matrix
skip_set_left:



    # If j < size - 1, set arr2[i][j+1] = '.'
    addi $t7, $t3, 1      # Increment j
    blt $t7, $t1, set_right
    j skip_set_right
set_right:
    addi $t4, $t4, 1      # $t4 = i * size + (j+1)
    add $t5, $a1, $t4     # $t5 = base address of arr2 + offset
    sb $t6, 0($t5)        # Store the byte at address $t5 with the value in $t6
skip_set_right:

skip:
    # Increment j and continue the inner loop
    addi $t3, $t3, 1
    j inner_loop_2

end_inner_loop_2:
    # Increment i and continue the outer loop
    addi $t2, $t2, 1
    j outer_loop_2

end_outer_loop:
    # Return from the function
    jr $ra
