#include <stdio.h>

int main()
{
    int op, a, b, result;

    printf("1: Soma; 2: Subtracao; 3: Multiplicacao; 4: Divisao \n");
    printf("Op: ");

    scanf("%d", &op);

    if (op < 1 || op > 4)
    {
        printf("Numero invalido");
        return 1;
    }

    printf("A: ");
    scanf("%d", &a);
    printf("B: ");
    scanf("%d", &b);

    if (op == 1) result = a + b;
    if (op == 2) result = a - b;
    if (op == 3) result = a * b;
    if (op == 4) result = a / b;

    printf("Resultado: %d", result);

    return 0;
}