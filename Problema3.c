#include <stdio.h>

int ehPitagorico(int A, int B, int C)
{
    return C * C == (A * A) + (B * B);
}

int main()
{
    int A, B, C;
    printf("Informe A: ");
    scanf("%d", &A);
    printf("Informe B: ");
    scanf("%d", &B);
    printf("Informe C: ");
    scanf("%d", &C);

    if (ehPitagorico(A, B, C))
        printf("Os numeros formam um Trio Pitagorico \n");
    else
        printf("Os numeros nao formam um Trio Pitagorico \n");

    return 0;
}