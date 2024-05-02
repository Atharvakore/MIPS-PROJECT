# vim:sw=2 syntax=asm

.text
  .globl simulate_automaton, print_tape

 
# Simulate one step of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, but updates the tape in memory location 4($a0)
simulate_automaton:
  # TODO
  jr $ra

# Print the tape of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return nothing, print the tape as follows:
#   Example:
#       tape: 42 (0b00101010)
#       tape_len: 8
#   Print:  
#       __X_X_X_
print_tape:
  # TODO
 # li $t0 0 
  #li $t1 0 
  li $t2 0 
 # li $t3 0 
 # li $t4 0 
  #li $t5 0
  lw $t0 4($a0) # tape in $t0
  lb $t1 8($a0) #tape length
  add $t4 $t1 $0
  loop1: 
  li $t3 0 
  beqz $t1 endloop1
  sll $t2 $t2 1
  andi $t3 $t0 1 
  add $t2 $t3 $t2
  add $t1 $t1 -1 
  srl $t0 $t0 1 
  j loop1 
  
endloop1:
li $t0 0 
add $t0 $t2 $0
j loop2

loop2:

beqz $t4 end
andi $t7 $t0 1 
bnez $t7 not0
li $a0 '_'
li $v0 11
syscall 
j hiha
not0:
li $a0 'X'
li $v0 11
syscall
j hiha
hiha:
add $t4 $t4 -1 
srl $t0 $t0 1  
j loop2

  
  
  end:
  li $a0 '\n'
  li $v0 11
  syscall
  jr $ra
