//Name: Sami Eljabali
//Program 18 Multiplying Matrices

#include <iostream>
#include <cstdlib>

using namespace std;

void print(int row, int col, int **ptr);

int main()
{
	int row, col, row2, col2,
		row3, col3, **ptr1, 
		**ptr2, **ptr3, i, 
		j, k;	
	char ans = 'y';
	
	while (ans == 'y')	
	{
		/*Input of # Rows & Cols*/
		cout << "Enter number of rows and columns of matrix #1: ";
		cin  >> row >> col;
		cout << endl << "Matrix #1 is " << row << " X " << col << endl;

		cout << "\nEnter number of rows and columns of matrix #2: ";
		cin  >> row2 >> col2;
		cout << endl << "Matrix #2 is " << row2 << " X " << col2<< endl;

		if (col != row2)
		{
			cout << "\nInvalid input!!";
			cin.get();
			cin.get();
			return 0;
		}
		
		row3 = row;
		col3 = col2;

		cout << endl << "Product matrix is " <<row3 << " X " 
			 << col3 << endl 
			 << "---------------------------------------------------";
		ptr1 = new int*[row];
		for (i=0; i<row; i++)
			ptr1[i] = new int[col];

		ptr2 = new int*[row2];
		for (i=0; i<row2; i++)
			ptr2[i] = new int[col2];
		
		ptr3 = new int*[row3];
		for (i=0; i<row3; i++)
			ptr3[i] = new int[col3];

		/*Inputting Vaules*/		
		cout << "\n\nEntering values for matrix #1\n";
		for (i = 0; i < row; i++)
		{
			for (j = 0; j < col; j++)
			{
				cout << "\nEnter value for row " << i + 1
					 <<" col " << j + 1 <<" : ";
				cin  >> ptr1[i][j];
			}		
		}
		
		cout << "\n\nEntering values for matrix #2\n";
		for (i = 0; i < row2; i++)
		{
			for(j = 0; j < col2; j++)
			{
				cout << "\nEnter value for row " << i + 1 
					 <<" col " << j + 1 <<" : "; 
				cin  >> ptr2[i][j];
			}		
		}
		/*Intializing ptr3 which needed to be done*/
		for (i = 0; i < row3; i++)
		{
			for(j = 0; j < col3; j++)
			{
				ptr3[i][j] = 0;
			}		
		}
		/*Calculating*/
		for (i = 0; i < row; i++)
		{
			for (j = 0; j < col2; j++)
			{
				for (k = 0; k < row; k++)
					ptr3[i][j] += ptr1[i][k] * ptr2[k][j];
			}
		}
		
		/*Outputting*/
		cout << "\nMatrix #1\n\n";
		print(row,  col,  ptr1);
		cout << "\nMatrix #2\n\n";
		print(row2, col2, ptr2);
		cout << "\nMatrix #3\n\n";
		print(row3, col3, ptr3);

		cout << "\nDo you wish to continue?[y/n] ";
		cin  >> ans;
		system("cls");
	}
	cin.get();
	return 0;
}

/*Print Function*/
void print(int row, int col, int **ptr)
{
	int i, j;

	for (i = 0; i < row; i++)
	{
		for (j = 0; j < col; j++)
		{
			cout << ptr[i][j] << "\t";
		}
		cout << endl;
	}	
}