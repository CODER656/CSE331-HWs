#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define size 4

// Function to input an 8*8 character matrix 
void inputMatrix(char matrix[size][size]) 
{
    printf("Enter elements of the %d*%d matrix:\n", size, size);

    for (int i = 0; i < size; i++) 
    {
        printf("Enter row %d: ", i + 1);
        for (int j = 0; j < size; j++) 
        {
            scanf(" %c", &matrix[i][j]);
        }
    }
}




void print(char arr[size][size]){

    for(int i=0; i<size; i++){
        for(int j=0; j<size; j++)
        {
            printf("%c",arr[i][j]);
        }
        printf("\n");
    }

}

void fill(char arr[size][size]){

        for(int i=0; i<size; i++)
            for(int j=0; j<size; j++)
                arr[i][j]='0';

}


//detonation function
void detonate_bomb(char arr[size][size],char arr2[size][size]){

    for(int i=0; i<size; i++){
        for(int j=0; j<size; j++)
        {

            if(arr[i][j]=='0'){

                arr2[i][j]='.';
                if(i > 0) arr2[i-1][j]='.';
                if(i < size-1) arr2[i+1][j]='.';
                if(j > 0) arr2[i][j-1]='.';
                if(j < size-1) arr2[i][j+1]='.';
                
            }
        }
    }

}

int main() 
{

    char matrix1[size][size];  
    char matrix2[size][size];  

    inputMatrix(matrix1);

    printf("\nInitial matrix:\n");
    print(matrix1);

    fill(matrix2);

    detonate_bomb(matrix1,matrix2);

    printf("\nFinal matrix:\n");
    print(matrix2);





    return 0;
}




