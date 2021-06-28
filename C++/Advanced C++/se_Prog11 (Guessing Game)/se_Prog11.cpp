//Program #11 The Guessing Game
//Name: Sami Eljabali
//Class: CS265-82
//Date: 7/12/04
#include <iostream>
#include <time.h>
#include <cstdlib>

using namespace std;

int CalcKow(int arr[3][4]);
int CalcKalf(int arr[3][4]);


int main()
{

	int arr[3][4], i, num, kow, kalf, bull, tries = 0;
	char temp[5] = {0}, YorN = 'y';

	
	while (YorN == 'y')
	{
		system("cls");
    tries = 0;
    kow = 0;
		cout << "Welcome to the Guessing Game!!\n";

		/*Generate random numbers then
		  assign them to Random[row 0]
		  and assign to Copy[row 2]*/
		srand((unsigned)time(NULL));

		for (i= 0; i < 4; i++)
		{
			num = ("%d",rand()) % 10;
			arr[0][i] = num;
			arr[2][i] = num;
		}
		while (kow != 4)
		{
		
			for (i = 0; i < 4; i++)

				arr[0][i] = arr[2][i]; //Restroring Random


			cout << "\n\nEnter a 4 digit number as your guess: ";
			cin  >> temp;

			//Converting chr to int vaules
			for (i = 0; i < 4; i++)

				arr[1][i] = temp[i] - 48;

 
			//Calling functions to calculate
			kow = CalcKow(arr);
			kalf = CalcKalf(arr);
			bull = 4 - (kow + kalf);

			//Output results
			cout << endl   << "Kows"    << "\tKalfs" 
				 << "\tBull\n" << "----" << "\t-----" 
				 << "\t----\n" <<  " " << kow  << "\t " 
				 << kalf << "\t  " << bull << endl;
			
			tries++;
		}

	cout << "\n\nCongradulations,you have guessed it!\n";

	if (tries == 1)
		cout << "Wow, you got it on your first try!!";
	else
		cout << "You got it in " << tries << " tries.";

	cout << "\n\nDo you want to play again?[y/n] ";
	cin  >> YorN;
	}

	return 0;
}



//Calculating Kows
int CalcKow(int arr[3][4])
{
	int i,kow = 0;

	for (i = 0; i < 4; i++)
	{
		if (arr[0][i] == arr[1][i])
		{
			arr[0][i] += 90;
			arr[1][i] += 80;
			kow++;
		}
	}

	return kow;
}

//Calculating Kalfs
int CalcKalf(int arr[3][4])
{
	int kalf = 0, i, j;

	for (j = 0; j < 4; j++)
	{
		for (i = 0; i < 4; i++)
		{
			if (arr[0][j] == arr[1][i])
			{
				arr[0][j] += 90;
				arr[1][i] += 80;
				kalf++;
			}
		}	
	}

	return kalf;
}