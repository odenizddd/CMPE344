.globl _start           

.section .data         
ARRAY: .word 2,7,8,4,9,1,11,3   

.section .text            
_start:                   
    la a0, ARRAY            # Load the base address
    addi a1, x0, 28         # Initialize end offset - make sure this equals (array size - 1) * 4
    
    OUTER_LOOP:
        beq a1, x0, OUTER_LOOP_EXIT
        addi a2, x0, 0      # Initialize offset

        INNER_LOOP:
            bge a2, a1, INNER_LOOP_EXIT

            add a3, a0, a2  # Find read address
            lw t0, 0(a3)
            lw t1, 4(a3)

            blt t0, t1, SKIP
            sw t0, 4(a3)
            sw t1, 0(a3)
            SKIP:

            addi a2, a2, 4  # Increase offset by 4
            beq x0, x0, INNER_LOOP
        
        INNER_LOOP_EXIT:
        addi a1, a1, -4     # Decrease end offset
        beq x0, x0, OUTER_LOOP

    OUTER_LOOP_EXIT:
