
.macro push(%reg)
	sub $sp, $sp, 4
	sw %reg, ($sp)
.end_macro

.macro pull(%reg)
	lw %reg, ($sp)
	add $sp, $sp, 8
.end_macro

.macro pushf(%reg)
	sub $sp, $sp, 8
	swc1 %reg, ($sp)
.end_macro

.macro pullf(%reg)
	lwc1 %reg, $sp
	add $sp, $sp, 8
.end_macro

.macro pushd(%reg)
	sub $sp, $sp, 8
	sdc1 %reg, ($sp)
.end_macro

.macro pulld(%reg)
	ldc1 %reg, ($sp)
	add $sp, $sp, 8
.end_macro


	
