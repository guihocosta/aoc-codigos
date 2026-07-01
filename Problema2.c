#include <stdio.h>

int main()
{
    int n;
    int i = 1;

    printf("N: ");
    scanf("%d", &n);

    if (n < 1)
    {
        printf("Invalido! O numero deve ser positivo. \n");
        return 1;
    }

    while (n != 1)
    {
        printf("%d \n", n);
        if (n % 2 == 0) n = n / 2;
        else n = n * 3 + 1;
        i++;
    }

    printf("%d \n", n);

    printf("Foram gerados %d termos \n", i);

    return 0;
}