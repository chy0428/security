#include <stdio.h>
#include <stdlib.h>
 
int main(){
    int *m = NULL;
    m = (int*)malloc(20 * sizeof(int));
 
    for(int i = 0; i < 20; i++){
        m[i] = i;
    }
 
    for(int i = 0; i < 20; i++){
        printf("%d\n", i);
    }
 
    free(m);
    return 0;
}

