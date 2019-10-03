.include "stack.s"

.macro malloc(%loc, %size)
	push($v0)
	push($a0)
	li $v0, 9
	move $a0, %size
	syscall
	move %loc, $v0
	pull($a0)
	pull($v0)
.end_macro

.macro malloci(%loc, %size)
	push($t0)
	li $t0, %size
	malloc(%loc, $t0)
	pull($t0)
.end_macro

.macro memcpy(%dest, %source, %size)
	push($t0)
	push($t1)
	li $t0, 0
lp0:	bge $t0, %size, end
	add %dest, %dest, $t0
	add %source, %source, $t0
	lw $t1, (%source)
	sw $t1, (%dest)
	sub %source, %source, $t0
	sub %dest, %dest, $t0
	add $t0, $t0, 4
	j lp0
end:	pull($t1)
	pull($t0)
.end_macro

.macro memcpyi(%dest, %source, %size)
	push($t2)
	li $t2, %size
	memcpy(%dest, %source, $t2)
	pull($t2)
.end_macro

.macro memset(%source, %val, %size, %valsize)
	push($t0)
	li $t0, 0
lp0:	bge $t0, %size, end
	push(%source)
	beq %valsize, 1, store_b
	beq %valsize, 4, store_w
	add %source, %source, $t0
store_b:sb %val, (%source)
	add $t0, $t0, 1
	j lpf
store_w:sw %val, (%source)
	add $t0, $t0, 4
lpf:	pull(%source)
	j lp0
end:	pull($t0)
.end_macro

.macro memseti(%source, %val, %size)
	push($t1)
	push($t2)
	li $t1, %val
	li $t2, 4
	memset(%source, $t1, %size, $t2)
	pull($t2)
	pull($t1)
.end_macro


	




