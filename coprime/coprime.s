.global _start

.equ M, 7

.data
D: .word 5,7,0, 8,24,0, 11,44,0, 11,18,0, 36,2,0, 63,27,0, 19,24,0

.text
_start:
    jal x1, coprime
    # pass arguments to gcd
    # addi a0, x0, 39
    # addi a1, x0, 91
    # call gcd: jal x1, gcd
    beq x0, x0, EXIT

coprime:
    addi sp, sp, -4
    sw x1, 0(sp)
    addi t0, x0, M
    la t1, D
    addi t2, x0, 1
    coprime_loop:
    beq t0, x0, coprime_exit

    # pass data here
    lw a0, 0(t1)
    addi t1, t1, 4
    lw a1, 0(t1)
    add t1, t1, 4

    # call gcd
    jal x1, gcd

    beq t2, a0, COP_CON1

    # not coprime
    addi t3, x0, 2
    sw t3, 0(t1)
    beq x0, x0, COP_CON2

    # coprime
    COP_CON1:
    addi t3, x0, 1
    sw t3, 0(t1)

    COP_CON2:
    add t1, t1, 4

    addi t0, t0, -1
    beq x0, x0, coprime_loop
    coprime_exit:
    lw x1, 0(sp)
    addi sp, sp, 4
    jalr x0, 0(x1)
    

# gcd function finds the gcd of a0 and a1 and returns the result into a0
# it also preserves the value of t0 but not of x1(return address)
# argument registers are also lost
gcd:
    # allocate space for t0
    addi sp, sp, -4
    sw t0, 0(sp)
    gcd_loop:
    bne a0, x0, GCD_CON1
    # put a1 into a0 to be returned
    add a0, a1, x0
    beq x0, x0, gcd_ret # jump to return procedure
    GCD_CON1:
    bne a1, x0, GCD_CON2
    beq x0, x0, gcd_ret
    GCD_CON2:
    bge a0, a1, GCD_CON3
    add t0, a0, x0
    add a0, a1, x0
    add a1, t0, x0
    GCD_CON3:
    rem t0, a0, a1
    add a0, t0, x0
    beq x0, x0, gcd_loop
    gcd_ret:
    lw t0, 0(sp)
    addi sp, sp, 4
    jalr x0, 0(x1)

EXIT:
    la t0, D