#include <stdlib.h>

#include "CppUTest/CommandLineTestRunner.h"

int main()
{
    const char* test_arguments[] = {
        "cross_platform_testing",
        "-v"
    };

    int result = CommandLineTestRunner::RunAllTests(2, test_arguments);

    exit(result);
}