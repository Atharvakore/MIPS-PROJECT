.data

# Memory layout of the Configuration
# |   eca  |   tape   |  tape_len  |  rule  |  skip  | column |
# | 1 word |  1 word  |   1 byte   | 1 byte | 1 byte | 1 byte |
configuration:
  .word 1       # eca
  .word 252     # tape
  .byte 8      # tape_len
  .byte 106    # rule
  .byte 5       # skip
  .byte 7       # column

.text 
.globl test
test:
 la $a0 configuration
 jal simulate_automaton

move $a0 $v1
li $v0 1 
syscall
li $v0 10
syscall
