/************************************************************************************************
            FILE:		se_magic.cpp
            AUTHOR:		Sami Eljabali
            PURPOSE:	To read in size the size of a sqaure, then to read in each row's values
						and then determine whether the square is a magic square or not.
            DATE:		11/03/2003
            INPUT:		Size of magic square and the vaules of its rows & columns.
            OUTPUT:		Display of whether the square is a magic square or not.
************************************************************************************************/

#include<iostream>

using namespace std;

int main()
{
  int square [10] [10],
      size = 0,
      sumrow,
      sumcol,
      sumdiag,
      sumdiag2,
      temp,
      col,
      row;

  bool TorF = true;
  

  //Reading in size of square
  cout << "Enter size of square (Zero to Stop): ";
  cin >> size;

  while (size != 0)
  {
      //Intializing
      temp = col = row = sumrow = sumcol = sumdiag = sumdiag2 = 0;

	  //Reading in values of square
	  cout << "Please enter the Rows of the square below: " << endl;
  
	  for (row = 0; row < size; row++)
	  {
		for (col = 0; col < size; col++)
		{
		  cin >> temp;
		  square[row][col] = temp;
		}
	  }
  
	  //Sum of rows
	  temp = 0;
	  for (col=0; col < size; col++) //First
		temp = square[0][col] + temp;
	  for (row = 1; row < size; row++) //Rest
	  {
		for (col = 0; col < size; col++)
		{
		  sumrow = square[row][col] + sumrow;
		}
		  if (sumrow != temp)//Comparing
		  {  
			TorF = false;
		  }
		sumrow = 0;
	  }
  

	  //Sum of columns
	  if (TorF == true)/* If one of the following is false then there
					      is no need to do further caluculations */
      {
		  temp = 0;
		  for (row = 0; row < size; row++)//First
			temp = square[row][0] + temp;
		  for (col = 1; col < size; col++)//Rest
		  {
			for(row = 0; row < size; row++)
			{
			  sumcol = square[row][col] + sumcol;
			}
			  if (sumcol !=temp)//Comparing
			  {
				TorF = false;
			  }
			  sumcol = 0;
		  }
	  }


	  //Sum of diagonal right to left
	  if (TorF == true)
      {
		  for(row=0; row<size; row++)
			sumdiag = square[row][row] + sumdiag;
		  
		  //Sum of diagonal from left to right
		  col = size - 1;
		  for(row = 0; row < size; row++)
		  {
			  sumdiag2 = square[row][col] + sumdiag2;
			  col--;
		  }

		  //Comparing diagonals
		  if(sumdiag != sumdiag2)
		  {
				TorF = false;
		  }
	  }
	  
	  //Display result
	  cout << endl;
	  if( TorF == false )

		cout << "It's not magic square!" << endl << endl;

	  else

		cout << "It's a magic square!" << endl << endl;

	  TorF = true;

	  //Reading in size of square
	  cout << "Enter size of square (Zero to Stop): ";
	  cin >> size;

  }

  cin.get();
  return 0;
}

