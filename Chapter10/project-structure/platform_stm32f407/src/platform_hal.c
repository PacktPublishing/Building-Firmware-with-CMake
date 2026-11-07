#include <errno.h>
#include <stdint.h>
#include <stdio.h>

#include "stm32f4xx_hal.h"

static UART_HandleTypeDef huart2;

static void UART_Init(void)
{
    huart2.Instance = USART2;
    huart2.Init.BaudRate = 115200;
    huart2.Init.WordLength = UART_WORDLENGTH_8B;
    huart2.Init.StopBits = UART_STOPBITS_1;
    huart2.Init.Parity = UART_PARITY_NONE;
    huart2.Init.Mode = UART_MODE_TX_RX;
    huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart2.Init.OverSampling = UART_OVERSAMPLING_16;

    if (HAL_UART_Init(&huart2) != HAL_OK)
    {
        for (;;)
        {
        }
    }
}

void PlatformHalInit(void)
{
    HAL_Init();
    UART_Init();
    setvbuf(stdout, NULL, _IONBF, 0);
}

int _write(int file, char *ptr, int len)
{
    (void)file;

    if (len < 0)
    {
        errno = EINVAL;
        return -1;
    }

    if (len > UINT16_MAX)
    {
        errno = EINVAL;
        return -1;
    }

    if (HAL_UART_Transmit(&huart2, (uint8_t *)ptr,
                          (uint16_t)len, HAL_MAX_DELAY) != HAL_OK)
    {
        errno = EIO;
        return -1;
    }

    return len;
}

void SysTick_Handler(void)
{
    // HAL_IncTick();
}
