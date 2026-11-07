#include <stdint.h>
#include <sys/stat.h>

int _fstat(int file, struct stat *st)
{
    (void)file;
    st->st_mode = S_IFCHR;
    return 0;
}

int _read(int file, char *ptr, int len)
{
    (void)file;
    (void)ptr;
    (void)len;
    return 0;
}

int _getpid(void)
{
    return 1;
}

__attribute__((noreturn)) void _exit(int status)
{
    struct {
        uint32_t reason;
        uint32_t status;
    } args = {
        0x20026,
        (uint32_t)status
    };

    register uint32_t operation __asm__("r0") = 0x20;
    register void *parameters __asm__("r1") = &args;

    __asm__ volatile(
        "bkpt 0xAB"
        : "+r"(operation)
        : "r"(parameters)
        : "memory"
    );

    for (;;)
    {
    }
}
