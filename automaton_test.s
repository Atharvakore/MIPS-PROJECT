.data
    .globl main
.globl automaton
# Memory layout of the Configuration
# |   eca  |   tape   |  tape_len  |  rule  |  skip  | column |
# | 1 word |  1 word  |   1 byte   | 1 byte | 1 byte | 1 byte |
automaton:
  .word 1       # eca
  .word 341    # tape
  .byte  9    # tape_len
  .byte 32     # rule
  .byte 1       # skip
  .byte 5       # column

.text

main:
 
loop:
 # beqz $s0 end
 # subi $s0 $s0 1
  la $a0 automaton
  #lw $a0 4($a0) #tape
 # jal print_tape
 # la $a0 automaton
  jal simulate_automaton
  jal print_tape
  #j loop
 
 
end:
  li      $v0 10
  syscall
