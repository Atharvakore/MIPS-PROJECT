# vim:sw=2 syntax=asm
.data 
.globl rule
rule: .space 8

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
   
  li $v1 0
  lw $a1 4($a0) #tape
  lb $a2 8($a0) #tape-length
  lb $a3 9($a0) # rule
  add $sp $sp -4 
  sw $ra 0($sp)   
  jal makeruleaccesible
  ### Every result would be stored in $t8 
  # Oth Packet 

andi $t1 $a1 1 #LSb in $t1
srl $a1 $a1 1 
andi $t2 $a1 1 #LLSb $t2
sll $t2 $t2 1 
add $t2 $t2 $t1
sll $t2 $t2  1

# MSB 
add $t3 $a1 $0
add $t4 $a2 -2
srlv $t3 $t3 $t4
andi $t3 $t3 1  #MSB in $t3 
add $t8 $t2 $t3
add $sp $sp -4
sw $t8 0($sp)
jal mutate 
 ######################### 0th Packet works perfectly FINE
 lw $a1 4($a0) #tape in $a1
 #counter in $s2
 li $s2 2
 HiHa:
 beq $s2 $a2 HiHaend
 andi $t8 $a1 7
 srl $a1 $a1 1 
 add $sp $sp -4
 sw $t8 0($sp)
 jal mutate
 add $s2 $s2 1
 j HiHa
  
HiHaend:
li $t0 0
li $t1 0 

# LAST Packet 
lw $a1 4($a0) #tape
lb $a2 8($a0) #tape-length
andi $t0 $a1 1  #LSb
sll $t0 $t0 2 #MSB for last packet
add $a2 $a2 -2 
srlv $a1 $a1 $a2
andi $a1 $a1 3
add $t0 $t0 $a1
move $t8 $t0 
add $sp $sp -4
sw $t8 0($sp)
jal mutate
# last packet end

# Now to reverse digits of $v1 and then saving to $a0(4)
 # $t0 has counter with tape length
 lb $a2 8($a0) #tape-length 
 li $t6 0 
 li $t6 0           # Initialize $t6 to store the result
add $t7 $a2 $0   
addu $t0 $v1 $0   #######ERROR error 
reverse_loop:
    sll $t6, $t6, 1     # Shift left logical $t6 by 1 bit
    andi $t1, $t0, 1    # Extract the least significant bit of $t0 and store it in $t1
    add $t6, $t6, $t1    # Combine the extracted bit with $t6
    srl $t0, $t0, 1     # Shift right logical $t0 by 1 bit
    addi $t7, $t7, -1   # Decrement the bit counter
    bnez $t7, reverse_loop  # Branch to reverse_loop if bit counter is not zero
    


###Last
  sw  $0    4($a0)
  sw  $t6   4($a0)
  lw $ra 0($sp)
  add $sp $sp 4 
  jr $ra
        
  
  
  ###############################################################
  
  mutate:
  lw $t8 0($sp)
  add $sp $sp 4
  sll $v1 $v1 1 
  li $t0 0
  li $t1 1 
  li $t2 2 
  li $t3 3 
  li $t4 4 
  li $t5 5 
  li $t6 6 
  li $t7 7 
  beq $t8 $t0 o_Index
  beq $t8 $t1 one_Index
  beq $t8 $t2 two_Index
  beq $t8 $t3 three_Index
  beq $t8 $t4 fourth_Index
  beq $t8 $t5 fifth_Index
  beq $t8 $t6 sixth_Index
  beq $t8 $t7 seventh_Index
  
  o_Index:
  lb $s1 rule
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  one_Index:
  lb $s1 rule + 1 
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  two_Index:
  lb $s1 rule + 2
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  three_Index:
  lb $s1 rule + 3 
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  fourth_Index:
   lb $s1 rule + 4
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  fifth_Index:
   lb $s1 rule + 5
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0 
  j mutateend 
  sixth_Index:
   lb $s1 rule + 6
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0
  j mutateend 
  seventh_Index:
   lb $s1 rule + 7
  andi $s1 $s1 1
  add $v1 $v1 $s1
  li $s1 0
  j mutateend 
  
 
  mutateend:
  	
  jr $ra
 
 
 ##################################################################
   makeruleaccesible:
   add $t0 $a3 $0 # $t0 has copy of rule
   andi $t1 $t0 1 
   sb $t1 rule  
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 1
   li $t1 0                         #Hiha Hiha Now the rule is easily accesible   101 %
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 2
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 3
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 4
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 5
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 6
   li $t1 0 
   srl $t0 $t0 1 
   andi $t1 $t0 1 
   sb $t1 rule + 7  
   li $t1 0 
   srl $t0 $t0 1 
   li $t0 0 
   jr $ra    
   #####################################################################
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
