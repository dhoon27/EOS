#include "stdint.h"
#include "stdbool.h"

#include "HalUart.h"
#include "HalInterrupt.h"
#include "HalTimer.h"

#include "stdio.h"
#include "stdlib.h"

static void hw_init(void);

static void printf_test(void);
static void Timer_test(void);

int main()
{
    hw_init();

    int i = 0;
    while(i--) {
        uint8_t ch = Hal_uart_get_char();
        Hal_uart_put_char(ch);

    }
    Hal_uart_put_char('\n');

    putstr("Hello World\n");
    
    printf_test();
    Timer_test();
    while(true);

    return 0;
}

static void hw_init()
{
    Hal_interrupt_init();
    Hal_uart_init();
    Hal_timer_init();
}

static void printf_test()
{
    char* str = "printf test";
    char* nullptr = 0;
    uint32_t i = 5;
    uint32_t* sysctrl0 = (uint32_t*)0x10001000;
    
    debug_printf("%s\n", "hello printf");
    debug_printf("str pointer : %s\n", str);
    debug_printf("%s is nullptr, %u number\n",nullptr, 10);
    debug_printf("dec = %u, hex = %x\n",0xff, 0xAA);
    debug_printf("SYSCTRL0 %x\n", *sysctrl0);
}

static void Timer_test(void)
{
    while(true)
    {
        debug_printf("current count : %u\n", Hal_timer_get_1ms_counter());
        delay(1000);
    }
}
