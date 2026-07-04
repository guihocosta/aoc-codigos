#include <stdio.h>

int main()
{
    int op, a, b, result;

    printf("1: Soma; 2: Subtracao; 3: Multiplicacao; 4: Divisao \n");
    printf("Op: ");

    scanf("%d", &op);

    if (op < 1 || op > 4)
    {
        printf("Numero invalido \n");
        return 1;
    }

    printf("A: ");
    scanf("%d", &a);
    printf("B: ");
    scanf("%d", &b);

    if (a < 0 || b < 0)
    {
        printf("Invalido! Os numeros devem ser positivos. \n");
        return 1;
    }

    if (op == 1) result = a + b;
    if (op == 2) result = a - b;
    if (op == 3) result = a * b;
    if (op == 4) result = a / b;

    printf("Resultado: %d \n", result);

    return 0;
}