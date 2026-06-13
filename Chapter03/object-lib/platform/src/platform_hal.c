#include <errno.h>
#include <stdio.h>
#include <sys/stat.h>

#include <stm32f0xx_hal.h>


static UART_HandleTypeDef huart1;

static void UART_Init(void)
{
    huart1.Instance = USART2;
    huart1.Init.BaudRate = 115200;
    huart1.Init.WordLength = UART_WORDLENGTH_8B;
    huart1.Init.StopBits = UART_STOPBITS_1;
    huart1.Init.Parity = UART_PARITY_NONE;
    huart1.Init.Mode = UART_MODE_TX_RX;
    huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    huart1.Init.OverSampling = UART_OVERSAMPLING_16;
    huart1.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
    huart1.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;

    huart1.MspInitCallback = NULL;

    HAL_UART_Init(&huart1);
}

void PlatformHalInit(void)
{
    HAL_Init();
    UART_Init();

    /* Disable I/O buffering for STDOUT stream, so that
    * chars are sent out as soon as they are printed. */
    setvbuf(stdout, NULL, _IONBF, 0);
}

int _write(int file, char *ptr, int len)
{
    (void)file;

    HAL_UART_Transmit(&huart1, (uint8_t *)ptr, (uint16_t)len, HAL_MAX_DELAY);
    return len;
}