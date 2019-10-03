
.macro printreg(%reg)
	push($v0)
	push($a0)
	move $a0, %reg
	li $v0, 4
	syscall
	pull($a0)
	pull($v0)
.end_macro

.macro prints(%label)
	push($a0)
	la $a0, %label
	printreg($a0)
	pull($a0)
.end_macro

.macro printss(%string)
	.data 
		string0: .asciiz %string
	.text
	prints(string0)
.end_macro

.macro printI(%int)
	.data newline: .asciiz "\n"
	.text
	push($v0)
	push($a0)
	move $a0, %int
	li $v0, 1
	syscall
	prints(newline)
	pull($a0)
	pull($v0)
.end_macro

.macro printIi(%num)
	push($a0)
	li $a0, %num
	printI($a0)
	pull($a0)
.end_macro

.macro exit(%reg)
	move $a0, %reg
	li $v0, 17
	syscall
.end_macro

.macro exiti(%val)
	li $a0, %val
	exit($a0)
.end_macro