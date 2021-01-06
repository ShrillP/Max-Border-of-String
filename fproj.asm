%include "simple_io.inc"
global asm_main 

SECTION .data
err1: dq "incorrect number of command line arguments",0
err2: dq "input string too long",0
msg1: dq "input string: ",0
msg2: dq "border array:",0
plus: dq "+++  ",0
dots: dq "...  ",0
space: dq "     ",0

SECTION .bss			;; this was changed
isborder: resq 1
max: resq 1
border: resq 12			;; initialized an empty arrray of length 12

SECTION .text

maxbord:
  enter 0,0
  saveregs

  mov qword [max], qword 0

  mov r12, [rbp+24]	;; length of string
  mov r13, [rbp+32]	;; input string

  mov rbx, qword 1	;; outer loop index (r)

  LOOP_1:
    cmp rbx, r12			;; first for loop
      je END_LOOP_1			;; when rbx = r1

    mov qword [isborder], qword 1	;; make isborder = 1
    mov r15, qword 0
    jmp LOOP_2

    LOOP_2:
      cmp r15, rbx			;; second for loop
        je END_LOOP_2			;; when i = r

      mov al, [r13+r15]

      mov r14, r12			;; create another instance of the input string length
      sub r14, rbx			;; subtract the length of input string by r  			
      add r14, r15			;; add i to length

      mov cl, [r13+r14] 		;; character at (L-r+i) of the string 
      inc r15

      cmp al, cl         		;; comapring characters of the string 
        je LOOP_2			;; if equal, continue with LOOP_2
      jmp PREP				;; else make isBorder = 0 and exit current loop 

      PREP:
        mov qword [isborder], qword 0
        inc rbx
        jmp LOOP_1

    END_LOOP_2:
      cmp qword [isborder], qword 1
        je SET_MAX	

      inc rbx
      jmp LOOP_1
      
      SET_MAX:				;; updates the max value only if max < r
        mov r11, rbx
        inc rbx
        
        cmp qword [max], r11
          jae LOOP_1

        mov qword [max], r11
        jmp LOOP_1
  
  END_LOOP_1:
    mov rax, qword [max]

  restoregs
  leave 
  ret

simple_display:
  enter 0,0
  saveregs

  mov r12, [rbp+24]		;; length of the string 
  mov r13, [rbp+32]		;; border array
  mov rcx, qword 1		;; interation variable 

  mov rax, msg2
  call print_string
  
  mov rax, [r13]
  call print_int

  DISPLAY:
    cmp rcx, r12
      ja END_DISPLAY

      mov al, ','
      call print_char

      mov al, ' '
      call print_char
     
      mov rax, [r13+rcx*8]
      call print_int
    
      inc rcx
      jmp DISPLAY

  END_DISPLAY:
    call print_nl

  restoregs
  leave
  ret

fancy_display:
  enter 0,0
  saveregs

  mov r12, [rbp+24]             ;; length of the string (L)
  mov r14, r12			;; copy of the length
  add r12, qword 1	        ;; restore the length (starting	from 1 instead of 0)
  
  mov r13, [rbp+32]             ;; border array
  mov rcx, r12  		;; for loop interation variable (level) 

  FANCY_LOOP:
    cmp rcx, qword 0
      je FANCY_LOOP_END

    mov rbx, qword 0            ;; count
    mov r15, qword 0            ;; x - for loop variable

    DISPLAY_LINE:
      cmp r15, r12
        jg DISPLAY_LINE_END

      mov r8, qword [r13+r15*8]

      inc rbx 
      cmp rbx, r12
        jg DISPLAY_LINE_END

      cmp rcx, qword 1
        je PRINT_1
      jmp PRINT_2
      
      PRINT_1:
        IF_1:
          cmp r8, qword 0
            jbe ELSE_1
       
          mov rax, plus
          call print_string
          jmp NEXT
        
        ELSE_1:
          mov rax, dots
          call print_string
          jmp NEXT

      PRINT_2:
        cmp r8, rcx
          jae ELSE_2
        jmp IF_2

        IF_2:
          mov rax, space
          call print_string
          jmp NEXT

        ELSE_2:
          mov rax, plus
          call print_string
          jmp NEXT 

      NEXT:
        inc r15
        jmp DISPLAY_LINE
      
    DISPLAY_LINE_END:
      dec rcx
      call print_nl 
      jmp FANCY_LOOP

  FANCY_LOOP_END:
    restoregs
    leave
    ret

asm_main:
  enter 0,0
  saveregs 

  cmp rdi, qword 2
    jne WRONG_NUM_ARGS

  mov r12, qword 0		;; counter
  mov r13, [rsi+8]		;; command line argument

  LENGTH:
    cmp byte [r13], byte 0	;; checks to see if null has been encountered 
      je LENGTH_CHECK

    inc r13
    inc r12
    jmp LENGTH

  LENGTH_CHECK:
    cmp r12, qword 12
      ja WRONG_LENGTH

  sub r13, r12			;; reset pointer of string to the beginning

  mov rax, msg1
  call print_string 

  mov rax, [rsi+8]
  call print_string
  call print_nl

  mov r14, r12			;; L1
  mov r15, qword 0		;; i (for loop interation variable) 

  sub r12, qword 1
  LOOP:
    cmp r15, r12
      jg END_LOOP

    push r13			;; push string onto stack
    push r14			;; push length of string 
    sub rsp, qword 8		;; dummy push 
    call maxbord
    mov qword [border+r15*8], rax
    add rsp, 24			;; clear stack 
    dec r14
    inc r15
    inc r13    
    jmp LOOP

  END_LOOP:
    push border
    push r12
    sub rsp, 8
    call simple_display
    add rsp, 24

    push border
    push r12
    sub rsp, 8
    call fancy_display
    add rsp, 24

    jmp asm_main_end

  WRONG_LENGTH:
    mov rax, err2
    call print_string 
    call print_nl
    jmp asm_main_end

  WRONG_NUM_ARGS:
    mov rax, err1
    call print_string
    call print_nl
    jmp asm_main_end

  jmp asm_main_end

asm_main_end:
  restoregs
  leave
  ret
