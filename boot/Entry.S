#include "ARMv7AR.h"
#include "memmap.h"

.text
    .code 32

    .global vector_start
    .global vector_end

    // reset pc는 0x00
    vector_start:
        LDR PC, reset_handler_addr // pc = reset_handler_addr 
        LDR PC, undef_handler_addr // Undefined Instruction
        LDR PC, svc_handler_addr // SVC
        LDR PC, pftch_abt_handler_addr // Instruction memory read fault
        LDR PC, data_abt_handler_addr // data memory read fault
        B . // 0x14 offset은 사용하지않음..
        LDR PC, irq_handler_addr // IRQ
        LDR PC, fiq_handler_addr // FIQ

        reset_handler_addr: .word reset_handler
        undef_handler_addr: .word dummy_handler
        svc_handler_addr: .word dummy_handler
        pftch_abt_handler_addr: .word dummy_handler
        data_abt_handler_addr: .word dummy_handler
        irq_handler_addr: .word Irq_Handler
        fiq_handler_addr: .word Fiq_Handler

    vector_end:
        // .space 1024, 0 // 현재 addr 부터 1024 bytes를 0으로 채움

    reset_handler:
        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_IRQ
        MSR cpsr, r1
        LDR sp, =IRQ_STACK_TOP

        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_FIQ
        MSR cpsr, r1
        LDR sp, =FIQ_STACK_TOP
        
        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_ABT
        MSR cpsr, r1
        LDR sp, =ABT_STACK_TOP
        
        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_UND
        MSR cpsr, r1
        LDR sp, =UND_STACK_TOP
        
        MRS r0, cpsr
        BIC r1, r0, #0x1F
        ORR r1, r1, #ARM_MODE_BIT_SYS
        MSR cpsr, r1
        LDR sp, =USRSYS_STACK_TOP

        BL main
        
    // reset_handler:
    //     LDR R0, =0x10000000
    //     LDR R1, [R0]

    dummy_handler:
        B .
    
.end
