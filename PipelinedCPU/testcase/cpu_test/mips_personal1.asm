.data
test_array: .word 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA
result:     .word 0x00

.text
main:
    # Load array element at index 3 into $t0
    lw $t0, 12($zero)  # 0x8c08000c
    
    # Load array element at index 4 into $t1
    lw $t1, 16($zero)  # 0x8c090010
    
    # Add $t0 and $t1 and store result in $t2
    add $t2, $t0, $t1  # 0x01094020
    
    # Store result in memory
    sw $t2, result     # 0xac0a0000
