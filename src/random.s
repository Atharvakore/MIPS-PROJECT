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
 
 # jal gen_bit 
  #move $t0 $v0 
   restart:
  sw $a0, arrr
  jal gen_bit 
  move $t0 $v0
  add $sp $sp -4
  sw $t0 0($sp)
  lw $a0, arrr 
  jal gen_bit
  lw $t0 0($sp)
  add $sp $sp 4
  move $t1 $v0
  bgtz $t0 checkt0
  j end
  
  
  checkt0:
  
  bgtz $t1 checkt1
  j end
  checkt1:
  lw $a0 arrr
  b restart
  



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
  addi $sp $sp -4 
  sw $ra 0($sp)
  sw $a0, arrr
  lw $a0, arrr
  lw $t0 0($a0) #eca
  beq $t0 $0 normal
  lb $s6 10($a0) #skip
  lb $s4 11($a0) #column
  lw $s5 4($a0) #tape
  lb $t9  8($a0) #tape_length
  loopskip:
  beqz $s6 loopskipend
  jal simulate_automaton 
  addi $s6 $s6 -1
  j loopskip 
   loopskipend:
  
     column:
   lw $t0 4($a0) #updated tape
   subiu $t9 $t9 1 
   subu $t9 $t9 $s4
   srlv $t0 $t0 $t9
   andi $v0 $t0 1 
   j endb
  # TODO
  normal:
  li $v0 40
  la $a1 4($a0)
  syscall
  li $v0 41
  li $a0 0
  syscall
  li $t0 0
  andi $v0 $a0 1 #random bit in $a0
  j endb
  
   
    
 endb: 
 lw $ra 0($sp) 
 add $sp $sp 4
 jr $ra


