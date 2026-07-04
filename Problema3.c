#include <stdio.h>

int ehPitagorico(int a, int b, int c)
{
    return c * c == (a * a) + (b * b);
}

int main()
{
    int a, b, c;
    printf("Informe A: ");
    scanf("%d", &a);
    printf("Informe B: ");
    scanf("%d", &b);
    printf("Informe C: ");
    scanf("%d", &c);

    if (a <=0 || b <= 0 || c <= 0)
    {
        printf("Invalido! Os numeros devem ser positivos. \n");
        return 1;
    }

    if (ehPitagorico(a, b, c))
        printf("Os numeros formam um Trio Pitagorico \n");
    else
        printf("Os numeros nao formam um Trio Pitagorico \n");

    return 0;
}