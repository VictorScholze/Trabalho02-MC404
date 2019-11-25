.globl _start
_start:
    # Configura o tratador de interrupções
    la t0, int_handler # Grava o endereço do rótulo int_handler
    csrw mtvec, t0 # no registrador mtvec
    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 7 (MPIE)
    ori t1, t1, 0x80 # do registrador mstatus
    csrw mstatus, t1
    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1
    # Ajusta o mscratch
    la t1, reg_buffer # Coloca o endereço do buffer para salvar
    csrw mscratch, t1 # registradores em mscratch
    # Muda para o Modo de usuário
    csrr t1, mstatus # Seta os bits 11 e 12 (MPP)
    li t2, ~0x1800 # do registrador mstatus
    and t1, t1, t2 # com o valor 00
    csrw mstatus, t1
    la t0, user # Grava o endereço do rótulo user
    csrw mepc, t0 # no registrador mepc
    mret # PC <= MEPC; MIE <= MPIE; Muda modo para MPP
# Trecho de código do usuário
.align 4
user:



read_ultrassonic_sensor:
    lw a7, 0xFFFF0020
    lw a0, 0
    sw a0, 0(a7)
    looplocal:
        lw a0, 0(a7)
        li t1, 1
        bne t1, a0, looplocal # if t1 != a0 then looplocal
    lw a7, 0xFFFF0024 # 
    lw a0, 0(a7) #
    ret
        
set_servo_angles:
    li t1, 1 # t1 = 0
    li t2, 2 # t2 = 1
    li t3, 3 # t3 = 2
    beq t1, a0, setservo0; # if t1 == a0 then setservo0
    beq t2, a0, setservo1; # if t2 == a0 then setservo1
    beq t3, a0, setservo2; # if t1 == a0 then setservo2
    blt a0, t1, wrongid # if a0 < t1 then wrongid
    bgt a0, t3, wrongid # if a0 > t3 then wrongid

    setservo0: #base servo
        li t1, 0 # t1 = 16
        li t2, 156 # t2 = 116
        blt a1, t1, outrange # if a1 < t1 then outrange
        bgt a1, t2, outrange # if a1 > t2 then outrange
        la a0, 0xFFFF001E # 
        sw a1, 0(a0) # 

    setservo1: #mid servo
        li t1, 0 # t1 = 52
        li t2, 156 # t2 = 90
        blt a1, t1, outrange # if a1 < t1 then outrange
        bgt a1, t2, outrange # if a1 > t2 then outrange
        la a0, 0xFFFF001D # 
        sw a1, 0(a0) # 

    setservo2: #top servo
        li t1, 0 # t1 = 0
        li t2, 156 # t2 = 156
        blt a1, t1, outrange # if a1 < t1 then outrange
        bgt a1, t2, outrange # if a1 > t2 then outrange
        la a0, 0xFFFF001C # 
        sw a1, 0(a0) # 
        # descobrir com acabar aqui########################

    wrongid:
        li a0, -2 # a0 = -2
    
    outrange:
        li a0, -1  # a0 = -1

set_engine_torque:
    li t0, -1 # a0 = -1
    li t1, 1 # t1 = 1
    
    beq a0, zero, seteng0; # if a0 == zero then seteng0
    beq a0, t1, seteng1; # if a0 == t1 then seteng1
    
    seteng0:
        
    seteng1:


read_gps:

read_gyroscope:

get_time:

set_time:

write:
