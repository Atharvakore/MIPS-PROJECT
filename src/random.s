#prints one random bit 
.text
  .globl gen_byte, gen_bit

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Compute the next valid byte (00, 01, 10) and put into $v0
#  If 11 would be returned, produce two new bits until valid
#
gen_byte:
  # TODO
  addi $sp, $sp, -4     # Adjust stack pointer
  sw   $ra, 0($sp)      # Save return address on stack
  jal gen_bit 
  move $t0 $v0 
  bgtz $t0 oint1   # I Would be Entering 0 in t1  
  jal gen_bit
  move $t1 $v0
  j end
  oint1:           #Im in 0 in t1
  jal gen_bit
  move $t1 $v0
  bgtz $t1 oint1
  end:
  sll $t0 $t0 1   #here Starts the end 
  addu $v0 $t0 $t1 
  lw   $ra, 0($sp)      # Restore return address from stack
  addi $sp, $sp, 4      # Restore stack pointer
  jr $ra

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Look at the field {eca} and use the associated random number generator to generate one bit.
#  Put the computed bit into $v0
#
gen_bit:

  # TODO
  li $v0 40
  la $a1 4($a0)
  syscall
  li $v0 41
  li $a0 0
  syscall
  andi $v0 $a0 1 #random bit in $a0
  jr $ra

