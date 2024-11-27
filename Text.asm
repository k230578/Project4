INCLUDE Irvine32.inc

.data
    menu BYTE "Scientific Calculator", 0dh, 0ah
     BYTE "1. Addition", 0dh, 0ah
     BYTE "2. Subtraction", 0dh, 0ah
     BYTE "3. Multiplication", 0dh, 0ah
     BYTE "4. Division", 0dh, 0ah
     BYTE "5. Logarithm (Base 10)", 0dh, 0ah
     BYTE "6. Natural Log (ln)", 0dh, 0ah
     BYTE "7. Sine (sin)", 0dh, 0ah
     BYTE "8. Cosine (cos)", 0dh, 0ah
     BYTE "9. Tangent (tan)", 0dh, 0ah
     BYTE "10. Square Root", 0dh, 0ah
     BYTE "11. Power (x^y)", 0dh, 0ah
     BYTE "Choose an option: ", 0
 prompt1 BYTE "Enter the number: ", 0
 prompt2 BYTE "Enter second number (if applicable): ", 0
 resultMsg BYTE "Result: ", 0
 invalidMsg BYTE "Invalid choice. Please try again.", 0
 divisionbyzero BYTE "Cannot Be Divided By Zero!!. Please Try Again!!", 0

.code
main PROC
    call Clrscr

    mov edx, OFFSET menu
    call WriteString
    call ReadInt
    mov ecx, eax

    cmp ecx, 1
    je addition
    cmp ecx, 2
    je subtraction
    cmp ecx, 3
    je multiplication
    cmp ecx, 4
    je division
    cmp ecx, 5
    je logarithm
    cmp ecx, 6
    je natural_log
    cmp ecx, 7
    je sine
    cmp ecx, 8
    je cosine
    cmp ecx, 9
    je tangent
    cmp ecx,10
    je SquareRoot
    cmp ecx,11
    je Power
    jmp invalid_choice

addition:
    call AdditionFunc
    jmp end_program

subtraction:
    call SubtractionFunc
    jmp end_program

multiplication:
   call MultiplicationFunc
    jmp end_program

division:
    call DivisionFunc
    jmp end_program

logarithm:
    call LogFunc
    jmp end_program

natural_log:
    call NaturalLog
    jmp end_program

sine:
    call SineFunc
    jmp end_program

cosine:
    call CosineFunc
    jmp end_program

tangent:
    call TangentFunc
    jmp end_program

SquareRoot:
call SquareRootFun
jmp end_program

Power:
call PowerFunc
jmp end_program

invalid_choice:
    mov edx, OFFSET invalidMsg
    call WriteString
    jmp end_program

end_program:
    call Crlf
    exit
main ENDP
AdditionFunc Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    mov edx, OFFSET prompt2
    call WriteString
    call ReadFloat
    fadd

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
ret
AdditionFunc EndP

SubtractionFunc Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    mov edx, OFFSET prompt2
    call WriteString
    call ReadFloat
    fsub

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
ret
SubtractionFunc EndP

MultiplicationFunc Proc
mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    mov edx, OFFSET prompt2
    call WriteString
    call ReadFloat
    fmul

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
ret
MultiplicationFunc EndP

DivisionFunc Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    mov edx, OFFSET prompt2
    call WriteString
    call ReadFloat

    fldz
    fcomi st(0), st(1)
    je division_by_zero

    fstp st(0)
    fdiv

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
    jmp endd

    division_by_zero:
    mov edx, OFFSET divisionbyzero
    call WriteString

endd:
ret
DivisionFunc EndP

LogFunc Proc
  mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat          ; Read input number
    fld st(0)               ; Push input to FPU stack

    fldlg2                  ; Load `log2(10)` onto FPU stack
    fxch st(1)              ; Swap input and `log2(10)`
    fyl2x                   ; Compute `log2(input) * 1/log2(10) = log10(input)`

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat         ; Display the result
    fstp st(0)
ret
LogFunc ENDP

NaturalLog Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat          
    fld st(0)              

    fldln2                  
    fxch st(1)            
    fyl2x                

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat        
    fstp st(0)      
ret
NaturalLog EndP
SineFunc Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    fsin

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
ret
SineFunc EndP
CosineFunc Proc
 mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat
    fld st(0)

    fcos

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat
ret
CosineFunc EndP
TangentFunc Proc
   mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat        
    fld st(0)            

    fld st(0)              
    fsin                  
    fld st(1)            
    fcos                
    fdiv                  

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat      
    fstp st(0)            
    fstp st(0)
ret
TangentFunc EndP
SquareRootFun PROC
    mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat          
    fld st(0)               ; Push the number onto the FPU stack

    fldz                    ; Load 0.0 onto the FPU stack
    fcomi st(0), st(1)      ; Compare input with 0.0
    ja square_root_error    ; Jump if input is less than 0.0
    fstp st(0)
    fsqrt                   ; Compute square root

    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat         ; Display the result
    fstp st(0)              ; Clean up FPU stack
    jmp square_root_end

square_root_error:
    fstp st(0)              ; Clean up FPU stack
    mov edx, OFFSET invalidMsg
    call WriteString        ; Print error message

square_root_end:
    ret
SquareRootFun ENDP
PowerFunc Proc
    mov edx, OFFSET prompt1
    call WriteString
    call ReadFloat          
    fld st(0)              

    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt          
    mov ecx, eax            

    cmp ecx, 0
    je power_zero_exponent  

    cmp ecx, 1
    je power_one_exponent    

    ; Initialize result
    fld1                    
    power_loop:
        fld st(1)          
        fmul                
        Loop power_loop
       
    jmp power_end

power_zero_exponent:
    fstp st(0)              
    fld1                    
    jmp power_end

power_one_exponent:
    fstp st(0)              
    jmp power_end

power_end:
    mov edx, OFFSET resultMsg
    call WriteString
    call WriteFloat        
    fstp st(0)

ret
PowerFunc EndP

END main