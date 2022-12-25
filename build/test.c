#include <stdio.h>

typedef struct smem{
//    char a,b;
    int c,d;
    double e,f;
}smem_t;

typedef union umem{
    char a:3;
    char b:5;
}umem_t;

int main()
{
    smem_t smem;
    umem_t umem;
    printf("smem = %d\numem= %d\n",sizeof(smem), sizeof(umem));
    
    umem.a = 0b101;
    umem.b = 0b11011;
    printf("umem.a = %c\numem.b = %c\n,umem.a,umem.b);

    return 0;
}
    
