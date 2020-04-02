#include <stdio.h>
#include "myprogram1.h"
  
int main() {

        int i=3;
        int j = 4;
        int m = test(i, j);
        printf("result: %d\n", m);
        return 0;
}

int test(int a, int b) {
	return a > b ? a : b;
}