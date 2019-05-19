#Timothy Dusek
#Spring 2019

.data #Delcare any varaibles here
	newBoard: 	.ascii "\n\n  | . . . . | . . . . | . . . . | . . . . |   a b c d"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   e f g h"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   i j k l"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   m n o p"
         	.asciiz  "\n  |   (0)   |   (1)   |   (2)   |   (3)   |   (index)\n"


	board: 	.ascii "\n\n  | . . . . | . . . . | . . . . | . . . . |   a b c d"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   e f g h"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   i j k l"
         	.ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   m n o p"
         	.asciiz  "\n  |   (0)   |   (1)   |   (2)   |   (3)   |   (index)\n"
         	
    offset: .half   6,   8,  10,  12,  16,  18,  20,  22,  26,  28,  30,  32,  36,  38,  40,  42
          	.half  60,  62,  64,  66,  70,  72,  74,  76,  80,  82,  84,  86,  90,  92,  94,  96
           	.half 114, 116, 118, 120, 124, 126, 128, 130, 134, 136, 138, 140, 144, 146, 148, 150
           	.half 168, 170, 172, 174, 178, 180, 182, 184, 188, 190, 192, 194, 198, 200, 202, 204

	pieceSelection: .asciiz "\nPlease select X or O\n"
	cellSelection: .asciiz "\nPlease select a valid cell (a-p)\n"
	gridSelection: .asciiz "\nPlease enter a valid grid (0-3)then press ENTER\n"
	continueSelection: .asciiz "\nWould you like to continue? (y/n)\n"
	newGameSelection: .asciiz "\nWould you like to start a new game? (y/n)\n"
	test: .asciiz "\ntest\n"
	
	invalidSelectionString: .asciiz "\nThat selection is not valid\n"
	
	userGamePiece: .word 0
	userGrid: .word 0
	userCell: .byte 'a'
	continue: .word 0
	newGame: .word 0

.text	#MIPS instructions go inside of a text segment
	main:	#Start of code section.
		
		#LA = load adress(to store something in a variable)
		#LI = Load immediately (to print )
	piece:	
		#asks user for piece selection
		li $v0, 4		#system call code for printing string = 4.
		la $a0, pieceSelection	#load address of string to be printed into $a0
		syscall			#call operating system to perform operation that is specified in $v0
	
		#user enters piece selection
		li $v0, 12
		syscall
		#error check for piece Selection
		beq $v0, 'X', L1
		beq $v0, 'O', L1
		li 	$v0, 4
		la 	$a0, invalidSelectionString
		syscall
		j piece
L1:	

		sb $v0, userGamePiece #assigns the users choice to the current game piece
		
		
		
		#prints game board
		li $v0, 4		#system call code for printing string = 4.
		la $a0, board 	#load address of string to be printed into $a0
		syscall			#call operating system to perform operation that is specified in $v0
		
	grid:
		#asks user for grid selection
		li $v0, 4
		la $a0, gridSelection
		syscall
		
		#user enters grid selection
		li $v0, 12
		syscall
		
		#error checking for user grid selection
		beq $v0, '0', L2
		beq $v0, '1', L2
		beq $v0, '2', L2
		beq $v0, '3', L2
gridError:
		li 	$v0, 4
		la 	$a0, invalidSelectionString
		syscall
		j grid
		
L2:	

		sub $v0, $v0, 48
		sb $v0, userGrid  #assigns the users grid choice to memory
		
	cell:
		#asks user for cell selection
		li $v0, 4
		la $a0, cellSelection
		syscall

		#user enters cell selection
		li $v0, 12	 #read char = 12
		syscall
 		
		beq $v0, 'a', L3
		beq $v0, 'b', L3
		beq $v0, 'c', L3
		beq $v0, 'd', L3
		beq $v0, 'e', L3
		beq $v0, 'f', L3
		beq $v0, 'g', L3
		beq $v0, 'h', L3
		beq $v0, 'i', L3
		beq $v0, 'j', L3
		beq $v0, 'k', L3
		beq $v0, 'l', L3
		beq $v0, 'm', L3
		beq $v0, 'n', L3
		beq $v0, 'o', L3
		beq $v0, 'p', L3
		li 	$v0, 4
		la 	$a0, invalidSelectionString
		syscall
		j cell

L3:

		sub $v0,$v0,'a' #subtracts a from the cell selection
		sb $v0, userCell  #assigns the users grid choice to memory
		
		
		lw	$t1,userCell  # loads the userCell data into $t1
		divu	$t1, $t1, 4 # divides $t1 by 4 and stores back into #t1
		mul	$t1 , $t1, 16# multiply into t1 by 16
	 	lw	$t2, userGrid # loads userGrid value into $t2
		mul	$t2, $t2 ,4 # multiply userGrid value by 4
		add $t0, $t1,$t2 # adds $t1 and $t2 but stores the value into $t0
		lw	$s0, userCell #loads userCell value ibto $s0
		divu	$t3, $s0, 4 #divides $s0 valie by 4 and stores it into $t3
		mfhi	$t3 #modulous operation
		add	$t0, $t0,$t3 # adds $t0 and $t3 and puts it into $t0
	
		mul	$t0, $t0, 2        # Becuase each offset is two-bytes long.
		
		lh	$t1, offset($t0)
		lb 	$t7, board($t1)      
		bne 	$t7, '.', gridError
		
		lw	$t2, userGamePiece #loads the UserGamePiece choice into $t2 to print to the board
		sb	$t2, board($t1)    # Put the piece at the location, board+offset.
		
		
		
		li	$v0, 4		#system call code for printing string = 4.
		la	$a0,board #load address of string to be printed into $a0
		syscall	
		
cont:  #checks to see if user wants to keep playing
		li $v0, 4
		la $a0, continueSelection
		syscall
		
		li $v0, 12
		syscall
		
		beq $v0, 'y', check1
		beq $v0, 'n', new
		
		li $v0, 4
		la $a0, invalidSelectionString
		syscall
		j cont
		
check1:

		lw $t1, userGamePiece #laods the current game piece in
		beq $t1, 'X', Ochange #checks if came piece is X if so jumps
xchange:
		li $v0, 'X' #changes game piece from O to X
		j L1

Ochange:
			li $v0, 'O' #changes the current piece from X to 0
			j L1
		
			
new: #asks user if they want to start a new game

		li $v0, 4
		la $a0, newGameSelection
		syscall
		
		li $v0, 12
		syscall
		
		beq $v0, 'y', resetGame
		beq $v0, 'n', endGame
		j new

resetGame:
		
		li $t0, 0
resetLoop: lb $t1, newBoard($t0) #address offset goes in the parenthesiss
		sb $t1, board($t0)
		add $t0, $t0, 1
		blt $t0, 256, resetLoop
		j piece

endGame:
		li $v0,10 #terminate program
		syscall
		
