.data
filename: .asciiz "text.bin" #file name
textSpace: .space 1050     #space to store strings to be read

.text
main:

li $v0, 13           #open a file
li $a1, 0            # file flag (read)
la $a0, filename         # load file name
add $a2, $zero, $zero    # file mode (unused)
syscall
move $a0, $v0        # load file descriptor
li $v0, 14           #read from file
la $a1, textSpace        # allocate space for the bytes loaded
li $a2, 1050         # number of bytes to be read
syscall  
la $a0, textSpace        # address of string to be printed
li $v0, 4            # print string
syscall