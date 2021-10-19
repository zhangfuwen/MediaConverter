#include <cstdio>

#define INFO(fmt, ...) printf("[%s:%d %s]" fmt, __FILE__, __LINE__, __func__,  ##__VA_ARGS__)

int main()
{
    INFO("hello world");
    return 0;
}
