#include <stdio.h>

int main()
{
    int N;
    int i = 1;

    printf("N: ");
    scanf("%d", &N);

    if (N < 1)
    {
        printf("Invalido! O numero deve ser positivo. \n");
        return 1;
    }

    while (N != 1)
    {
        printf("%d \n", N);
        if (N % 2 == 0) N = N / 2;
        else N = N * 3 + 1;
        i++;
    }

    printf("%d \n", N);

    printf("Foram gerados %d termos \n", i);

    return 0;
}