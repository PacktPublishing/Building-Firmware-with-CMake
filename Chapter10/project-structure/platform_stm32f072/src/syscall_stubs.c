#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>

// int _close(int file)
// {
//     (void)file;
//     return -1;
// }

int _fstat(int file, struct stat *st)
{
    (void)file;
    st->st_mode = S_IFCHR;
    return 0;
}

// int _isatty(int file)
// {
//     (void)file;
//     return 1;
// }

// off_t _lseek(int file, off_t ptr, int dir)
// {
//     (void)file;
//     (void)ptr;
//     (void)dir;
//     return 0;
// }

int _read(int file, char *ptr, int len)
{
    (void)file;
    (void)ptr;
    (void)len;
    return 0;
}

// void *_sbrk(ptrdiff_t incr)
// {
//     (void)incr;
//     errno = ENOMEM;
//     return (void *)-1;
// }

// void _exit(int status)
// {
//     (void)status;
//     while (1)
//     {
//     }
// }

int _getpid(void)
{
    return 1;
}

// int _kill(int pid, int sig)
// {
//     (void)pid;
//     (void)sig;

//     errno = EINVAL;
//     return -1;
// }

// int _gettimeofday(struct timeval *tv, void *tz)
// {
//     (void)tz;

//     if (tv != NULL)
//     {
//         tv->tv_sec = 0;
//         tv->tv_usec = 0;
//     }

//     return 0;
// }

// int _open(const char *name, int flags, int mode)
// {
//     (void)name;
//     (void)flags;
//     (void)mode;

//     errno = ENOSYS;
//     return -1;
// }

void _exit(int status)
{
    struct {
        uint32_t reason;
        uint32_t status;
    } args = {
        0x20026, // ADP_Stopped_ApplicationExit
        (uint32_t)(status)
    };

    register uint32_t operation asm("r0") = 0x20; // SYS_EXIT_EXTENDED
    register void* parameters asm("r1") = &args;

    asm volatile(
        "bkpt 0xAB"
        : "+r"(operation)
        : "r"(parameters)
        : "memory"
    );

    for (;;) {
    }
}
