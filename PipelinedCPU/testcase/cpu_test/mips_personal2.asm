.text
main:
    # Initialize registers with values
    addi $t0, $zero, 5        # 0x20080005
    addi $t1, $zero, 7        # 0x20090007
    
    # Add $t0 and $t1 and store result in $t2
    add $t2, $t0, $t1         # 0x01094020
    
    # Store result in memory
    addi $t3, $zero, 4096     # 0x200b1000
    sw $t2, 0($zero)            # 0xad4b0000

