.eqv ImgInfo_fname	0
.eqv ImgInfo_hdrdat 4
.eqv ImgInfo_imdat	8
.eqv ImgInfo_width	12
.eqv ImgInfo_height	16
.eqv ImgInfo_lbytes	20

.eqv MAX_IMG_SIZE 	147546 # 768 x 64 x 3 (piksele) 
#.eqv MAX_IMG_SIZE 	90000 # 600 x 50 x 3 (piksele) 


.eqv BMPHeader_Size 54
.eqv BMPHeader_width 18
.eqv BMPHeader_height 22

.eqv system_OpenFile	1024
.eqv system_ReadFile	63
.eqv system_WriteFile	64
.eqv system_CloseFile	57

	.data
.include		"data.asm"
imgInfo: .space	24
	
	.align 2
dummy:		.space 2
bmpHeader:	.space	BMPHeader_Size

	.align 2
imgData: 	.space	MAX_IMG_SIZE

ifname:	.asciz "white.bmp"	#plik wejsciowy
ofname: .asciz "result.bmp"

test_string: .asciz "00100010"

file_error_msg:		.asciz "UNABLE TO READ FILE\n"
too_long_barcode: 	.asciz "BARCODE IS TOO LONG\n"
not_parity_number:	.asciz "NUMBER OF CHARS HAVE TO BE PARITY\n"



output:			.space 	100

	.text
main:
	# wypełnienie deskryptora obrazu
	la a0, imgInfo 			
	
	la t0, ifname
	sw t0, ImgInfo_fname(a0)
	
	la t0, bmpHeader		
	sw t0, ImgInfo_hdrdat(a0)
	
	la t0, imgData			
	sw t0, ImgInfo_imdat(a0)
	
	jal	read_bmp
	bnez a0, main_failure
	
	la a0, imgInfo
	j code

save_prep:
	la a0, imgInfo
	la t0, ofname
	sw t0, ImgInfo_fname(a0)
	jal save_bmp
	
exit:
	li	a7, 10
	ecall
	
	
main_failure:
	li 	a7, 4
	la 	a0, file_error_msg
	ecall
	li 	a7, 10
	ecall
	
######################################
# faza obsugi plikow bmp
#####################################


	
save_bmp:
	mv t0, a0
	
#open file
	li a7, system_OpenFile
    lw a0, ImgInfo_fname(t0)	#file name 
    li a1, 1			#flags: 1-write file
    ecall
	
	blt a0, zero, wb_error
	mv t1, a0
	
#write header
	li a7, system_WriteFile
	lw a1, ImgInfo_hdrdat(t0)
	li a2, BMPHeader_Size
	ecall
	
#write image data
	li a7, system_WriteFile
	mv a0, t1
	# compute image size (linebytes * height)
	lw a2, ImgInfo_lbytes(t0)
	lw a1, ImgInfo_height(t0)
	mul a2, a2, a1
	lw a1, ImgInfo_imdat(t0)
	ecall

#close file
	li a7, system_CloseFile
	mv a0, t1
    ecall
	
	mv a0, zero
	jr ra
	
wb_error:
	li a0, 2 # error writing file
	jr ra
	
read_bmp:
	mv t0, a0
	
#open file
	li a7, system_OpenFile
    	lw a0, ImgInfo_fname(t0)	#file name 
    	li a1, 0			
    	ecall
	
	blt a0, zero, rb_error			#blad otwierania pliku
	mv t1, a0
	
#read header
	li a7, system_ReadFile
	lw a1, ImgInfo_hdrdat(t0)
	li a2, BMPHeader_Size
	ecall
	
#extract image information from header
	lw a0, BMPHeader_width(a1)	
	sw a0, ImgInfo_width(t0)
	

	add a2, a0, a0
	add a0, a2, a0	# pixelbytes = width * 3 
	addi a0, a0, 3
	srai a0, a0, 2
	slli a0, a0, 2	# linebytes = ((pixelbytes + 3) / 4 ) * 4
	sw a0, ImgInfo_lbytes(t0)
	
	lw a0, BMPHeader_height(a1)
	sw a0, ImgInfo_height(t0)
	
#read image data
	li a7, system_ReadFile
	mv a0, t1
	lw a1, ImgInfo_imdat(t0)
	li a2, MAX_IMG_SIZE
	ecall
	
#close file
	li a7, system_CloseFile
	mv a0, t1
    	ecall
	
	mv a0, zero
	jr ra
	
rb_error:
	li a0, 1	# error opening file	
	jr ra
	
######################################################
# faza kodowania
######################################################	
	
	
code:	
	lw t0, ImgInfo_imdat(a0)
	lw a5, ImgInfo_imdat(a0)
	addi t0, t0, 30
	li t2, 0x00000000
	
	mv a4, zero

	
	jal black_column # rysowanie start C
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 6
	jal black_column
	addi t0, t0, 9
	jal black_column
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 6
	
	la a3, test_string
	
numbers_loop:

	lbu t3, (a3)
	beqz t3, control_sum
	addi t3, t3, -48 	# konwersja na int
	slli t3, t3, 3		# mnozenie razy 8
	add t3, t3, t3
	add t3, t3, t3		# mnozymy razy 10 pierwsza liczbe
	
	addi a3, a3, 1
	
	lbu t4, (a3)
	beqz t4, parity_error
	addi t4, t4, -48	# konwersja na int
	
	add t3, t3, t4		# liczba -> 10* cyfra dziesietna + cyfra jednosci
	
	slli t3, t3, 2
	
	la t6, array_of_codes
	add t6, t6, t3
	lw t3, (t6)
	
	addi a3, a3, 1
	j draw_number
	
control_sum:
	li t4, 105
	rem a4, a4, t4
	
	slli a4, a4, 2
	
	la t6, array_of_codes
	add t6, t6, a4
	lw t3, (t6)
	li t4, 0x400
	
draw_control_loop:
	
	and t5, t4, t3
	addi t0, t0, 3
	srli t4, t4, 1
	beqz t4, end_mark
	beqz t5, draw_control_loop
	jal black_column
	j draw_control_loop
	
end_mark:
	addi t0, t0, 3
	jal black_column # za użyciem end mark rysujemy koniec - [Stop - 11000111010]
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 12
	jal black_column
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 3
	jal black_column
	addi t0, t0, 6
	jal black_column
	addi t0, t0, 6
	
	li t4, 2214
	sub a5, t0, a5
	bgt a5, t4, length_error
	
	
	j save_prep

length_error:
	li a7, 4
	la a0, too_long_barcode
	ecall
	li 	a7, 10
	ecall

parity_error:
	li a7, 4
	la a0, not_parity_number
	ecall
	li a7, 10
	ecall
draw_number:
	li t4, 0x400
draw_number_loop:
	
	and t5, t4, t3
	addi t0, t0, 3
	srli t4, t4, 1
	beqz t4, numbers_loop
	beqz t5, draw_number_loop
	jal black_column
	
	
	j draw_number_loop

black_column:
	mv s6, zero
	mv s3, t0
	li s5, 64
	lw s4, ImgInfo_lbytes(a0)
black_column_loop:
	beq s6, s5, return
	sb t2, (t0)
	sb t2, 1(t0)
	sb t2, 2(t0)
	
	addi s6, s6, 1
	add t0, t0, s4
	j black_column_loop
return:
	mv t0, s3
	jr ra
