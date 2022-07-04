#2020CSB1127                                      
#Queue Data structure
#Queue will be stored at address 0x10001000 after dequeue opearation front pointer increment 
.data
str: .asciiz "E -1 E -6  E 34  D S D"   # User input E,D,S are case sensitive 

E: .asciiz "E"
D: .asciiz "D"
S: .asciiz "S"
Zero :.byte '0'
Minus: .byte '-'

.text
la x3 str #global pointer traversing string
lb x5 E
lb x6 D
lb x7 S
lb x29 Minus # '-'ascii value
lb x25 Zero  #'0' ascii value
addi x19 x0 32 # space ascii value
addi x27 x0 3 
addi x31 x0 1
slli x31 x31 11
lui x29  0xFFFFF
addi x29 x29 0x7FF
add x29 x29 x31


addi x28 x0 1
slli x28 x28 12
lui x8 0x10000
add x8 x8 x28 #address 0x10001000 (For enqueue)
add x21 x0 x8 #front pointer
add x22 x0 x8 #rear pointer

addi x28 x0 4
slli x28 x28 12
add x9 x8 x28 #address 0x10005000 (size is stored at this address)


Loop:
lb x20 0(x3)
beq x20 x0 Exit
beq x20 x5 Enqueue
beq x20 x6 Dequeue
beq x20 x7 Size

addi x3 x3 1
beq x0 x0 Loop

Enqueue: #Enqueue subroutine
addi x3 x3 2
addi x30 x0 0
lb x18 0(x3)
beq x18 x29 E1 #Checking the negative sign , if so x30 becomes 8


L1:  
lb x18 0(x3)
beq x18 x19 Loop
beq x18 x0 Exit
sub x18 x18 x25 #Convert character into integer by -'0'

L2:
addi x23 x0 0
add x23 x18 x0 
lb x24 1(x3)    #loading digit
beq x24 x19 L3  #If digit equals space L3
sub x24 x24 x25
addi x26 x0 0   # i=0
L4:             #For multiplyting the digit by 10
bge x26 x27 LL  # i<3
add x18 x18 x23  
add x18 x18 x23
add x18 x18 x23
addi x26 x26 1
beq x0 x0 L4
LL:            #After multiplying adding next digit to form integer
add x18 x18 x24
addi x3 x3 1
lb x24 1(x3)
beq x24 x0 L3
bne x24 x19 L2
L3:
bne x30 x0 N # Check negative number
sw x18 0(x8)
addi x8 x8 4
addi x22 x22 4
beq x0 x0 Loop

E1:
addi x30 x0 8 #x30 becomes 8 means negative number
addi x3 x3 1
beq x0 x0 L1

N:              #For negative numbers to convert them into 2's complement
xor x18 x18 x29 #Inverting the binary
addi x18 x18 1  #adding 1 to it
sw x18 0(x8)    #Storing 2's complement at x8
addi x8 x8 4
addi x22 x22 4
beq x0 x0 Loop


Size: #Size subroutine
addi x26 x26 0
sub x26 x22 x21 #x26 stores the value of subtraction of front and rear pointers
srli x26 x26 2  # Divide x26 by 4 to obtain the size
sw x26 0(x9)    # Stores sixe at (0x10005000)
addi x3 x3 1
beq x0 x0 Loop

Dequeue: #Dequeue Subroutine
beq x22 x21 LLL
addi x3 x3 1
lw x26 0(x21)
addi x26 x0 0  
sw x26 0(x21)   #Dequeue the element by storing 0 at its place
addi x21 x21 4  # Incrementing the front pointer
beq x0 x0 Loop
LLL:
lb x26 0(x3)
beq x26 x0 Exit


Exit:
