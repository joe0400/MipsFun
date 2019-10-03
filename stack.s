
.macro push(%reg)
	sub $sp, $sp, 4
	sw %reg, ($sp)
.end_macro

.macro pull(%reg)
	lw %reg, ($sp)
	add $sp, $sp, 4
.end_macro

