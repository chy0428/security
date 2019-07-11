#include <stdio.h>

int add(int x, int y);
int main(){
    int x = 5, y = 10;
    int result = add(x, y);
    printf("result = %d\n", result);
}
int add(int x, int y){
    return x + y;
}
