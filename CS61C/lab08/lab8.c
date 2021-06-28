#include <stdio.h>

long fib(unsigned long n);

long fib(unsigned long n) {
 
    if (n < 2) {
        return n;
    } else {
        return fib(n-1)+fib(n-2);
    }
}
int main()
{
    long n;

    n = fib(7);
    
    printf("%d ",n);
    return 0;
}
