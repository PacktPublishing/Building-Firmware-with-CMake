#include <cstdint>

#include <CppUTest/TestHarness.h>
#include <stm32f0xx_hal.h>

TEST_GROUP(UartConfiguration)
{
};

TEST(UartConfiguration, Configures115200Baud)
{
    constexpr std::uint32_t baud_rate = 115200U;

    const std::uint32_t peripheral_clock = HAL_RCC_GetPCLK1Freq();
    const std::uint32_t expected_brr =
        (peripheral_clock + (baud_rate / 2U)) / baud_rate;

    UNSIGNED_LONGS_EQUAL(
        0U,
        USART2->CR1 & USART_CR1_OVER8
    );

    UNSIGNED_LONGS_EQUAL(
        expected_brr,
        USART2->BRR
    );
}