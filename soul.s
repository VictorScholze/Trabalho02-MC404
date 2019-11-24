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
        sw a0, 0(a7) #
        ret
        
set_servo_angles:
    li t1, 1 # t1 = 1
    li t2, 2 # t2 = 2
    li t3, 3 # t3 = 3
    beq t3, a0, setservo3; # if t1 == a0 then setservo3
    beq t2, a0, setservo2; # if t2 == a0 then setservo2
    beq t1, a0, setservo1; # if t1 == a0 then setservo1
    blt a0, t1, wrongid # if a0 < t1 then wrongid
    bgt a0, t3, wrongid # if a0 > t3 then wrongid
    setservo3:
        lw t1, 0 # 
        lw t2, 156 # 
        blt a1, t1, outrange3 # if a1 < t1 then outrange3
        bgt a1, t2, outrange3 # if a1 > t2 then outrange3

        outrange3:
            li a0, -1  # a0 = -1
            ret
    setservo2:

    setservo1:

    wrongid:
        li a0, -2 # a0 = -2
        ret a0

    
#0xFFFF001C	3 top 0 156   0xFFFF001D 2 mid 52 90    0xFFFF001E 1 base 16 116