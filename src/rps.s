# vim:sw=2 syntax=asm
.data
.globl arrr
arrr:
.space 4
win:.asciiz "W"
loose:.asciiz "L"
Tie:.asciiz "T"
.text
  .globl play_game_once

# Play the game once, that is
# (1) compute two moves (RPS) for the two computer players
# (2) Print (W)in (L)oss or (T)ie, whether the first player wins, looses or ties.
#
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, only print either character 'W', 'L', or 'T' to stdout
play_game_once:
  # TODO
 #t2 has 2 , t3 has 1 , t4 has 0 
 sw $a0, arrr
 addi $sp, $sp, -4     # Adjust stack pointer
 sw   $ra, 0($sp)      # Save return address on stack

  lw $a0, arrr 
  jal gen_byte 
  move $t5 $v0
  add $sp $sp -4
  sw $t5 0($sp)
  lw $a0, arrr
  jal gen_byte
   li $t2 2
  li $t3 1 
  li $t4 0
  lw $t5 0($sp)
  add $sp $sp 4 
  move $t6 $v0 
  beq $t5 $t6 equal
  beq $t5 $t2 tohas2
  beq $t5 $t3 tohas1
  beq $t5 $t4 tohas0
  
  tohas2:
  beq $t6 $t3 winn
  beq $t6 $t4 looose
  tohas1:
  beq $t6 $t4 winn
  beq $t6 $t2 looose
  tohas0:
  beq $t6 $t2 winn
  beq $t6 $t3 looose
  equal: #I am in EQUAL
  li $v0 4 
  la $a0 Tie
  syscall
  j end
  
  winn: #I am in WINN
  la $a0 win
  li $v0 4 
  syscall
  j end
  
  looose: #I am in looose
  la $a0 loose 
  li $v0 4 
  syscall
  j end
  
  end:
  lw   $ra, 0($sp)      # Restore return address from stack
  addi $sp, $sp, 4      # Restore stack pointer
  jr $ra
