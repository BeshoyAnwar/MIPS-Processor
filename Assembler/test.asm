Loop: sll $t1,$s1,2
srl $s6,$t5,5
add $s1, $s2, $s3
addi $s1, $s2, 100
sub $s1, $s2, $s3
lw $s1, 100($s2)
lui $s1, 100
j Exit
sw $s1, 100($s2)
slt $s1, $s2, $s3
beq $s1, $s2, Loop
Test: lui $s1, 100
bne $s1, $s2, Exit
Exit:beq $t1, $s2, Test
beq $t2,$s1, Loop
jr $ra
EQ: addi $t0, $t2, 1000
lw $t5, 100($t2)
jal Exit