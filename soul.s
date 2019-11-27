#tratador de interrupcoes
#salva contexto
.globl _start
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
    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch

#verificar mcause
    csrr s10, mcause # lê a causa da exceção
    bgez s10, escolhe_syscall # desvia se não for uma interrupção

    li t1, 0xFFFF0100 # t1 = 0xFFFF0100 guarda valor para gerar interrupcao
    li t2, 0xFFFF0104 # t2 = 0xFFFF0104 1-ha interrupcao/0-n ha interrupcao
    bnez t2, trata_gpt
    j restaura_contexto
trata_gpt:
    la t3, tempo # 
    lw t4, 0(t3)
    addi t4, t4, 100; # t4 = t4 + 100
    sw t4, 0(t3) # 
    sb zero, 0(t2) # 
    li t5, 100 # t5 = 100
    sw t5, 0(t1) # 
    j restaura_contexto
    
#escolhe_syscall
escolhe_syscall:
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
    

#implementacao syscall 
#le sensor ultrassonico
read_ultrassonic_sensor:
    li a7, 0xFFFF0020
    li a0, 0
    sw a0, 0(a7)
    looplocal:
        lw a0, 0(a7)
        li t1, 1
        bne t1, a0, looplocal # if t1 != a0 then looplocal
    li a7, 0xFFFF0024 # 
    lw a0, 0(a7) #
    j restaura_contexto

#seta os angulos do servo #######################################################checar se deixo a verificacao aqui ou nao
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
        li a0, 0xFFFF001E # 
        sb a1, 0(a0) # 
        li a0, 0 # a0 = 0
        j restaura_contexto

    setservo1: #mid servo
        li t1, 0 # t1 = 52
        li t2, 156 # t2 = 90
        blt a1, t1, outrange # if a1 < t1 then outrange
        bgt a1, t2, outrange # if a1 > t2 then outrange
        li a0, 0xFFFF001D # 
        sb a1, 0(a0) # 
        li a0, 0 # a0 = 0
        j restaura_contexto

    setservo2: #top servo
        li t1, 0 # t1 = 0
        li t2, 156 # t2 = 156
        blt a1, t1, outrange # if a1 < t1 then outrange
        bgt a1, t2, outrange # if a1 > t2 then outrange
        li a0, 0xFFFF001C # 
        sb a1, 0(a0) # 
        li a0, 0 # a0 = 0
        j restaura_contexto

    wrongid:
        li a0, -2 # a0 = -2
        j restaura_contexto
    
    outrange:
        li a0, -1  # a0 = -1
        j restaura_contexto

#seta torque dos motores
set_engine_torque:
    li t0, -1 # a0 = -1
    li t1, 1 # t1 = 1
    
    beq a0, zero, seteng0; # if a0 == zero then seteng0
    beq a0, t1, seteng1; # if a0 == t1 then seteng1
    li a0, -1 # a0 = -1
    j restaura_contexto

    seteng0:
        li a0, 0 # a0 = 0
        li t1, 0xFFFF001A # 
        sh  a1, 0(t1) # 
        j restaura_contexto

    seteng1:
        li a0, 0 # a0 = 0
        li t1, 0xFFFF0018 # 
        sh a1, 0(t1) # 
        j restaura_contexto

#le gps
read_gps:
    li t1, 0xFFFF0004 # 
    sw zero, 0(t1) # atribui 0 para iniciar leitura do gps
    
    loopgps:
        lw t2, 0(t1) #
        li t3, 1 # t3 = 1
        beq t2, t3, gpslido; # if t2 == t3 then gpslido
        j loopgps  # jump to loopgps

    gpslido:
        li s1, 0xFFFF0008 # t1 = 0xFFFF0008 valor do x
        lw t1, 0(s1) # 
        sw t1, 0(a0) # 
        li s2, 0xFFFF000C # t2 = 0xFFFF000C valor do y
        lw t2, 0(s2) #
        sw t2, 4(a0) # 
        li s3, 0xFFFF0010 # t3 = 0xFFFF0010 valor do z
        lw t3, 0(s3) # 
        sw t3, 8(a0) # 
        j restaura_contexto

#le giroscopio
read_gyroscope:
    li t1, 0xFFFF0004 # 
    sw zero, 0(t1) # atribui 0 para iniciar leitura do giroscopio

    loopgyro:
        lw t2, 0(t1) #
        li t3, 1 # t3 = 1
        beq t2, t3, gyrolido; # if t2 == t3 then gyrolido
        j loopgyro  # jump to loopgyro

    gyrolido:
        li s3, 0xFFFF0014 # s3 = 0xFFFF0014
        andi t3, s3, 1023 #t3 tem valor de z

        srli s2, s3, 10
        andi t2, s2, 1023 #t2 tem valor do y

        srli s1, s2, 10
        andi t1, s1, 1023 #t1 tem valor do x

        sw t1, 0(a0) # 
        sw t2, 4(a0) # 
        sw t3, 8(a0) # 
        j restaura_contexto
        
#pega o tempo
get_time:
    la t1, tempo
    lw a0, 0(t1)
    j restaura_contexto

#seta o tempo
set_time:
    la t1, tempo
    sw a0, 0(t1) # 
    j restaura_contexto
    
#escreve na UART
write:
    li t1, 0xFFFF0109 # t1 = 0xFFFF0109 valor a ser transmitido pela UART
    li t2, 0xFFFF0108 # t2 = 0xFFFF0108 registrador que inicia transmissao
    li t3, 1 # t3 = 1
    li t4, 0 # t4 = 0 contador
    
    inicia:
        lb s1, 0(a1) # carrega valor em s1
        sb s1, 0(t1) # coloca valor no endereco de transmissao
        sb t3, 0(t2) # inicia transmissao
        addi t4, t4, 1; # t4 = t4 + 1
    
    transmite:
        bnez t2, transmite #enquanto t2 != 0 transmite
    
    beq t4, a2, fim_transmissao; # if t4 == a2 then fim_transmissao
    addi a1, a1, 1; # a1 = a1 + 1
    j inicia

    fim_transmissao:
        mv  a0, t4 # a0 = t4
        j restaura_contexto
        

restaura_contexto:
    
    csrrw a0, mscratch, a0 # troca valor de a0 com mscratch
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
    csrr a1, mepc 
    addi a1, a1, 4
    csrw mepc, a1
    mret


_start:
    # Setta os valores iniciais do uoli
    # Torque zero nos motores
    li t1, 0xFFFF001A # t1 = 0xFFFF001A endereco do torque motor 1
    li t2, 0xFFFF0018 # t2 = 0xFFFF0018 endereco do torque motor 2
    sh zero, 0(t1) # 
    sh zero, 0(t2) # 

    # Angulo dos servos
    #top
    li t3, 0xFFFF001C # t3 = 0xFFFF001C endereco do top servo
    li t1, 78 # t1 = 78
    sb t1, 0(t3) # 
    #mid
    li t4, 0xFFFF001D # t4 = 0xFFFF001D endereco do mid servo
    li t2, 80 # t2 = 80
    sb t2, 0(t4) # 
    #base
    li t5, 0xFFFF001E # t5 = 0xFFFF001E endereco do base servo
    li t6, 31 # t6 = 31
    sb t6, 0(t5) # 
    
    # Configura o gpt
    la t4, tempo # 
    sw zero, 0(t4) # 
    li t1, 0xFFFF0100 # t1 = 0xFFFF0100 guarda valor para gerar interrupcao
    li t2, 100 # t2 = 100
    sw t2, 0(t1) # guarda 100 no t1
    li t3, 0xFFFF0104 # t3 = 0xFFFF0104
    sw zero, 0(t3) # zera o registrador q indica uma interrupcao
    
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

tempo: .skip 4
.align 4

reg_buffer:
    .skip 5000
    .word 0

user:
    call main

laco:
    j laco
