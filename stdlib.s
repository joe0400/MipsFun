.include "stack.s"
.include "stdio.s"

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
	lb $t1, (%source)
	sb $t1, (%dest)
	sub %source, %source, $t0
	sub %dest, %dest, $t0
	add $t0, $t0, 1
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

.macro memsetf(%source, %val, %size, %valsize)
	push($t0)
	li $t0, 0
lp0:	bge $t0, %size, end
	push(%source)
	beq %valsize, 4, flt
	beq %valsize, 8, dbl
flt:	add %source, %source, $t0
	swc1 %val, (%source)
	pull(%source)
	add $t0, $t0, 4
	j lp0
dbl:	add %source, %source, $t0
	sdc1 %val, (%source)
	pull(%source)
	add $t0, $t0, 8
	j lp0
end:	pull($t0)
.end_macro

.macro gen_double(%data, %address)
	.data
		d: .double %data
	.text
	push($t0)
	la $t0, d
	ldc1 %address, ($t0)
	pull($t0)
.end_macro

.macro gen_float(%data, %address)
	.data
		f: .float %data
	.text
	push($t0)
	la $t0, f
	lwc1 %address, ($t0)
	pull($t0)
.end_macro

.macro memsetfi(%source, %val, %size, %valsize)
	push($t0)
	push($t1)
	pushd($f0)
	li $t1, %valsize
	beq $t1, 4, fl
	gen_double(%val, $f0)
	j cont
fl:	gen_float(%val, $f0)
cont:	memsetf(%source, $f0, %size, $t1)
	pulld($f0)
	pull($t1)
	pull($t0)
.end_macro
.macro xmalloc(%loc, %size)
	malloc(%loc, %size)
	bnez %loc, fin
	printss("XMALLOC FAILED FOR SIZE ")
	printI(%size,"")
	exiti(10)
fin:	
.end_macro

.macro xmalloci(%loc, %size)
	push($a0)
	li $a0, %size
	xmalloc(%loc, $a0)
	pull($a0)
.end_macro

.macro calloc(%loc, %size)
	push($t2)
	push($t3)
	malloc(%loc, %size)
	li $t2, 0
	li $t3, 1
	memset(%loc,$t2,%size,$t3)
	pull($t3)
	pull($t2)
.end_macro

.macro calloci(%loc, %size)
	push($t4)
	li $t4, %size
	calloc(%loc, $t4)
	pull($t4)
.end_macro

.macro double_array(%addr, %size)
	mul %size, %size, 8
	malloc(%addr, %size)
	div %size, %size, 8
.end_macro

.macro double_arrayi(%addr, %size)
	push($a0)
	li $a0, %size
	double_array(%addr, $a0)
	pull($a0)
.end_macro
.macro word_array(%addr, %size)
	mul %size, %size, 4
	malloc(%addr, %size)
	div %size, %size, 4
.end_macro
.macro word_arrayi(%addr, %size)
	push($a0)
	li $a0, %size
	word_array(%addr, $a0)
	pull($a0)
.end_macro
.macro byte_array(%addr, %size)
	malloc(%addr, %size)
.end_macro
.macro byte_arrayi(%addr, %size)
	push($a0)
	li $a0, %size
	byte_array(%addr, $a0)
	pull($a0)
.end_macro
	
.macro realloc(%addr, %new_size, %original_size)
	push($t5)
	calloc($t5, %new_size)
	blt %new_size, %original_size, orig
	memcpy($t5, %addr, %original_size)
	j fin
orig:	memcpy($t5, %addr, %new_size)
fin:	move %addr, $t5
	pull($t5)
.end_macro

.macro realloci(%addr, %new_size, %original_size)
	push($t6)
	push($t7)
	li $t6, %new_size
	li $t7, %original_size
	realloc(%addr, $t6, $t7)
	pull($t7)
	pull($t6)
.end_macro




