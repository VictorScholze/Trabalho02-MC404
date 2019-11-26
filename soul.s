#tratador de interrupcoes
#salva contexto
int_handler:
    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch
    sw a1, 0(a0) # salva a1
    sw a2, 4(a0) # salva a2
    sw a3, 8(a0) # salva a3
    sw a4, 12(a0) # salva a4
    sw a5, 16(a0) # 
    sw a6, 20(a0) # 
    sw a7, 24(a0) # 
    sw s0, 28(a0) # 
    sw s1, 32(a0) # 
    sw s2, 36(a0) # 
    sw s3, 40(a0) # 
    sw s4, 44(a0) # 
    sw s5, 48(a0) # 
    sw s6, 52(a0) # 
    sw s7, 56(a0) # 
    sw s8, 60(a0) # 
    sw s9, 64(a0) # 
    sw s10, 68(a0) # 
    sw s11, 72(a0) # 
    sw t0, 76(a0) # 
    sw t1, 80(a0) # 
    sw t2, 84(a0) # 
    sw t3, 88(a0) # 
    sw t4, 92(a0) # 
    sw t5, 96(a0) # 
    sw t6, 100(a0) # 
    sw ra, 104(a0) # 
    sw sp, 108(a0) # 
    sw gp, 112(a0) # 
    sw tp, 116(a0) # 

#escolhe_syscall

    li t1, 16 # t1 = 16
    beq a7, t1, read_ultrassonic_sensor; # if a7 == t1 then read_ultrassonic_sensor

    li t1, 17 # t1 = 17
    beq a7, t1, set_servo_angles; # if a7 == t1 then set_servo_angles
    
    li t1, 18 # t1 = 18
    beq a7, t1, set_engine_torque; # if a7 == t1 then set_engine_torque
    
    li t1, 19 # t1 = 19
    beq a7, t1, read_gps; # if a7 == t1 then read_gps
    
    li t1, 20 # t1 = 20
    beq a7, t1, read_gyroscope; # if a7 == t1 then read_gyroscope
    
    li t1, 21 # t1 = 21
    beq a7, t1, get_time; # if a7 == t1 then get_time
    
    li t1, 22 # t1 = 22
    beq a7, t1, set_time; # if a7 == t1 then set_time
    
    li t1, 64 # t1 = 64
    beq a7, t1, write; # if a7 == t1 then write
    

#implementacao syscall ###########################################fazer o final dos rotulos########################

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
        ############ como terminar

    wrongid:
        li a0, -2 # a0 = -2
    
    outrange:
        li a0, -1  # a0 = -1

set_engine_torque:
    li t0, -1 # a0 = -1
    li t1, 1 # t1 = 1
    
    beq a0, zero, seteng0; # if a0 == zero then seteng0
    beq a0, t1, seteng1; # if a0 == t1 then seteng1
    li a0, -1 # a0 = -1
    ####### da r um jump pra algum canto

    seteng0:
        li a0, 0 # a0 = 0
        la t1, 0xFFFF001A # 
        sw a1, 0(t1) # 
        #######finalizar com jump
    seteng1:
        li a0, 0 # a0 = 0
        la t1, 0xFFFF0018 # 
        sw a1, 0(t1) # 
        #######finalizar com jump

read_gps:

read_gyroscope:

get_time:

set_time:

write:


restaura_contexto:

    lw tp, 116(a0) # 
    lw gp, 112(a0) #
    lw sp, 108(a0) # 
    lw ra, 104(a0) # 
    lw t6, 100(a0) # 
    lw t5, 96(a0) # 
    lw t4, 92(a0) # 
    lw t3, 88(a0) # 
    lw t2, 84(a0) # 
    lw t1, 80(a0) # 
    lw t0, 76(a0) # 
    lw s11, 72(a0) # 
    lw s10, 68(a0) # 
    lw s9, 64(a0) # 
    lw s8, 60(a0) # 
    lw s7, 56(a0) # 
    lw s6, 52(a0) # 
    lw s5, 48(a0) # 
    lw s4, 44(a0) # 
    lw s3, 40(a0) # 
    lw s2, 36(a0) # 
    lw s1, 32(a0) # 
    lw s0, 28(a0) # 
    lw a7, 24(a0) # 
    lw a6, 20(a0) # 
    lw a5, 16(a0) # 
    lw a4, 12(a0) # 
    lw a3, 8(a0) # 
    lw a2, 4(a0) # 
    lw a1, 0(a0) # 

    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch



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
.align 4

