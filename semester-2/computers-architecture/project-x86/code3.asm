section .data
    codes:  dd  0x6CC, 0x66C, 0x666, 0x498, 0x48C, 0x44C, 0x4C8, 0x4C4, 0x464, 0x648,
            dd  0x644, 0x624, 0x59C, 0x4DC, 0x4CE, 0x5CC, 0x4EC, 0x4E6, 0x672, 0x65C,
            dd  0x64E, 0x6E4, 0x674, 0x76E, 0x74C, 0x72C, 0x726, 0x764, 0x734, 0x732,
            dd  0x6D8, 0x6C6, 0x636, 0x518, 0x458, 0x446, 0x588, 0x468, 0x462, 0x688,
            dd  0x628, 0x622, 0x5B8, 0x58E, 0x46E, 0x5D8, 0x5C6, 0x476, 0x776, 0x68E,
            dd  0x62E, 0x6E8, 0x6E2, 0x6EE, 0x758, 0x746, 0x716, 0x768, 0x762, 0x71A,
            dd  0x77A, 0x642, 0x78A, 0x530, 0x50C, 0x4B0, 0x486, 0x42C, 0x426, 0x590,
            dd  0x584, 0x4D0, 0x4C2, 0x434, 0x432, 0x612, 0x650, 0x7BA, 0x614, 0x47A,
            dd  0x53C, 0x4BC, 0x49E, 0x5E4, 0x4F4, 0x4F2, 0x7A4, 0x794, 0x792, 0x6DE,
            dd  0x6F6, 0x7B6, 0x578, 0x51E, 0x45E, 0x5E8, 0x5E2, 0x7A8, 0x7A2, 0x5DE,
            dd  0x5EE, 0x75E, 0x7AE, 0x684, 0x690, 0x69C, 0x18EB

    %define     text              [ebp-4]
    %define     szerokosc         [ebp-8]
    %define     first_pixel       [ebp-12]
    %define     suma_contr          [ebp-16]
    %define     stos                [ebp-20]
    %define     eax_save            [ebp-24]

; sciaga z rejestrow
; eax - tekst
; ebx
; ecx - ecx szerokosc
; edx - dh wykorzystywany jako składniowa białego, dl licznik petli bialej
; esp - licznik sumy kontrolnej
; ebp - stos????
; esi - adres piksela
; edi


section .text
global code
code:
    push    ebp                     ;prolog
    mov     ebp, esp
    sub esp, 24

    mov esi, [ebp+8]  ; adres 1 piksela
    mov eax, [ebp+12] ; adres z tekstem
    mov ecx, [ebp+16]  ; szerokosc

    mov text, eax
    mov szerokosc, ecx
    mov first_pixel, esi
    mov stos, esp


    mov dh, 255    ; skladniowa bialej

    call white_line ; quiet zone
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line

    add esi, 6      ; start A
    call white_line
    add esi, 3
    call white_line
    call white_line
    call white_line
    call white_line
    add esi, 3
    call white_line
    call white_line
    sub esi, 3
    mov first_pixel, esi





draw_numbers:
    mov esp, 0 ; sp to licznik sumy kontrolnej
    mov suma_contr, esp
    mov eax, text

draw_numbers_loop:
    xor edx, edx
    mov edx, [eax]
    inc eax
    and edx, 255 ; and na x-1 == %x
    cmp edx, 0
    je control_sum_draw

    add edx, 64 ; pod edx mamy numer poszukiwany
    ;operacja modulu ktora jest giga skomplikowana
    ;i jestem totalnym szefem ze to zrobilem es
    mov eax_save, eax
    mov eax, edx
    mov dh, 96
    div dh
    shr eax, 8
    and eax, 255
    mov edx, eax
    mov eax, eax_save

    mov esp, suma_contr
    add esp, edx
    mov suma_contr, esp

    mov ecx, codes
    mov ecx, [ecx + edx * 4] ;dziala dla niektorych liczb, wrocic i naprawic
    




;znak na ecx chyba bedzie
draw_number:
    mov edi, 1024
    mov esi, first_pixel
    ;sub esi, 3
draw_number_loop:
    mov esp, ecx
    and esp, edi
    add esi, 3
    
    cmp edi, 0
    je draw_numbers_loop
    
    shr edi, 1
    cmp esp, 0
    
    
    jne draw_number_loop
    
line:
    mov dl, 0
    mov first_pixel, esi
    mov dh, 255
    
line_loop:
    mov [esi], dh
    inc esi
    mov [esi], dh
    inc esi
    mov [esi], dh
    add esi, szerokosc
    inc dl
    cmp dl, 64
    jne line_loop
    mov esi, first_pixel
    jmp draw_number_loop


control_sum_draw:
    

    mov ecx, suma_contr
    
    mov eax_save, eax
    mov eax, ecx
    mov dh, 103
    div dh
    shr eax, 8
    and eax, 255
    mov ecx, eax
    
    
    mov eax, codes
    mov ecx, [eax + ecx * 4]
    mov eax, eax_save
    xor edi, edi
    mov edi, 1024
    mov esi, first_pixel



draw_control_loop:
    mov esp, ecx
    and esp, edi
    add esi, 3
    
    cmp edi, 0
    je draw_end
    
    shr edi, 1
    cmp esp, 0
    jne draw_control_loop
    
control_line:
    mov dl, 0
    mov first_pixel, esi
    mov dh, 255
    
control_loop:
    mov [esi], dh
    inc esi
    mov [esi], dh
    inc esi
    mov [esi], dh
    add esi, szerokosc
    inc dl
    cmp dl, 64
    jne control_loop
    mov esi, first_pixel
    jmp draw_control_loop

draw_end:
    mov esp, stos
    add esi, 6
    call white_line
    call white_line
    call white_line
    add esi, 9
    call white_line
    add esi, 3
    call white_line
    add esi, 6
    mov first_pixel, esi


exit:
    call white_line ; quiet zone
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    call white_line
    mov    esp, ebp
    pop    ebp
    ret

white_line:
    mov first_pixel, esi
    mov dl, 0
    mov ecx, szerokosc
    mov dh, 255
    
white_line_loop:
    mov [esi], dh
    inc esi
    mov [esi], dh
    inc esi
    mov [esi], dh
    add esi, ecx
    inc dl
    cmp dl, 64
    jne white_line_loop
    mov esi, first_pixel
    add esi, 3
    mov first_pixel, esi
    ret
