#include <stdio.h>
#include <stdlib.h>

int main() {
    int choice;
    printf("Select language for lexical analysis:\n");
    printf("1. C\n2. Python\n3. Java\n");
    printf("Enter choice: ");
    scanf("%d", &choice);

    switch(choice) {
        case 1:
            system("flex c_lexer.l && gcc lex.yy.c -o c_lexer && .\\c_lexer < input.c");
            break;
        case 2:
            system("flex python_lexer.l && gcc lex.yy.c -o python_lexer && .\\python_lexer < input.py");
            break;
        case 3:
            system("flex java_lexer.l && gcc lex.yy.c -o java_lexer && .\\java_lexer < input.java");
            break;
        default:
            printf("Invalid choice.\n");
    }
    return 0;
}
