.globl set_torque
.globl set_engine_torque
.globl set_head_servo
.globl get_us_distance
.globl get_current_GPS_position
.globl get_gyro_angles
.globl get_time
.globl set_time
.globl puts

set_torque:
    li a2, 100
    li a3, -100
    blt a2, a0, invalido #se o valor do torque 1 for maior que 100
    blt a0, a3, invalido # se o valor do torque 1 for menor que -100
    blt a2, a1, invalido #se o valor do torque 2 for maior que 100
    blt a1, a3, invalido # se o valor do torque 2 for menor que -100
    mv a5, a0 #move o valor do torque do motor 1 para a5
    li a0, 1 #coloca o id do motor 2 que é 1 no a0
    li a7, 18 # coloca o código 18 da syscall set_engine_torque 
    ecall #chamada do sistema
    li a0, 0 # coloca id do motor 1 que é 0 no a0
    mv a1, a5 #coloca o valor do torque do motor 1 que estava em a5 no a1
    ecall
    ret
    li a0, 0 #retorna 0 caso os dois valores sejam válidos
    invalido:
        li a0, -1 #se for caso invalido retorna -1 no a0
        ret

set_engine_torque:
    li a2, 100
    li a3, -100
    li a4, 1
    blt a2, a1, torque_invalido #se o valor do torque 2 for maior que 100
    blt a1, a3, torque_invalido # se o valor do torque 2 for menor que -100
    beqz a0, valido #se nao for igual a 0 vai pro codigo
    beq a0, a4, valido # se for igual a 1 vai pro codigo
    li a0, -2 # se o valor do id for invalido retorna -2 no a0
    ret

    valido:
        li a7, 18 # coloca o código 18 da syscall set_engine_torque 
        ecall #chamada do sistema
        ret 
    torque_invalido:
        li a0, -1 #se for caso invalido retorna -1 no a0
        ret

set_head_servo:
    beqz a0, base
    li a5, 1
    beq a0, a5, mid
    li a5, 2
    beq a0, a5, top
    li a0, -1 # se nao for nenhum dos ids válidos, então retorna -1
    ret

    base:
        li a2, 116 #carrega o valor maximo
        li a3, 16 #carrega o valor minimo
        blt a2, a1, angulo_invalido #se o valor do angulo for maior que 116
        blt a1, a3, angulo_invalido # se o valor do angulo for menor que 16
        j chamado
    mid:
        li a2, 90 #carrega o valor maximo
        li a3, 52 #carrega o valor minimo
        blt a2, a1, angulo_invalido #se o valor do angulo for maior que 90
        blt a1, a3, angulo_invalido # se o valor do angulo for menor que 52
        j chamado
    top:
        li a2, 156 #carrega o valor maximo
        li a3, 0 #carrega o valor minimo
        blt a2, a1, angulo_invalido #se o valor do angulo for maior que 90
        blt a1, a3, angulo_invalido # se o valor do angulo for menor que 52
        j chamado

    chamado:
        li a7, 17 # coloca o código 17 da syscall set_servo_angles  
        ecall #chamada do sistema
        ret

    angulo_invalido:
        li a0, -2 # se nao for nenhum dos angulos validos entao retorna -1
        ret

get_us_distance:
    li a7, 16 # coloca o código 16 da syscall read_ultrasonic_sensor   
    ecall #chamada do sistema
    #ao == -1   0xFFFF
    li a2, -1
    beq a0, a2, caso_negativo
    caso_negativo:
        li a0, 0xFFFF 
    ret

get_current_GPS_position:
    li a7, 19 # coloca o código 19 da syscall read_gps    
    ecall #chamada do sistema
    ret

get_gyro_angles:
    li a7, 20 # coloca o código 20 da syscall read_gyroscope     
    ecall #chamada do sistema
    ret

get_time:
    li a7, 21 # coloca o código 21 da syscall get_time     
    ecall #chamada do sistema
    ret

set_time:
    li a7, 22 # coloca o código 22 da syscall set_time      
    ecall #chamada do sistema
    ret

puts:
    li a7, 64 # coloca o código 64 da syscall write       
    ecall #chamada do sistema
    ret
