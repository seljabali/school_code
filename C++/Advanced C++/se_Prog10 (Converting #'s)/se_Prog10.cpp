//Program #10 Converting numbers
//Name: Sami Eljabali
//Class: CS265-82
//Date: 7/6/04


#include <iostream>
#include <cmath>
#include <cstdlib>

using namespace std;

void ArabictoRoman();
void RomantoArabic();

int main()
{
	int choice,
		Arabic[50] = {0};
	
	
	char Roman[50] = {0};
	
	//MENU SCREEN
	cout << "Welcome to the Number Converter v1.0!!\n\n";
	
	do
	{
		
	    cout << "                  MENU \n\n"
		   	<< "[1] Convert an Arabic number to a Roman Numeral.\n"
			<< "[2] Convert a Roman Numeral to an Arabic Number.\n"
			<< "[3] Clear the screen.\n"
			<< "[4] Quit the program.\n\n"
			<< "Please select a task you wish to do: ";
		cin  >> choice;
		cout << endl;
		
		//choice determines which function to chose
		if (choice == 1)
			ArabictoRoman();
		
		else if (choice == 2)
			RomantoArabic();
		
		else if (choice == 3)
			system("cls");
		
		else if ((choice < 1) || (choice > 4))
			cout << "\nPlease enter a valid choice!!\n\n";
		
	} while (choice != 4);
	
	cin.get();
	return 0;
}

//ARABIC TO ROMAN FUNCTION
void ArabictoRoman()
{
	int ArabicLookup[13] = {1000, 900, 500, 400, 100, 90,
		50, 40, 10, 9, 5, 4, 1},
		Remainder[14] = {0}, i, j = 0, Arabic = 0;
	
	char RomanLookup[14] = {'M','C','D','C','C','X','L','X','X','I','V','I','I'},
		 RomanLookup2[14] = {'\0','M','\0','D','\0','C','\0','L','\0','X','\0','V','\0'};
	
	cout << "\nPlease enter an Arabic number: ";
	cin  >> Arabic;
	
	
	for (i = 0; i< 13; i++)
	{
		Remainder[i] = Arabic / ArabicLookup[i];
		
		if (Remainder[i] > 0)
			Arabic = Arabic % ArabicLookup[i];
	}

  cout << "\nThe Arabic number is ";
	
	for (i = 0; i < 13; i++)
	{
		while (Remainder[i] > 0)
    {
      cout << RomanLookup[i];
      if (RomanLookup2[i] != '\0')
        cout << RomanLookup2[i];
      Remainder[i]--;
    }
	}

	cout << "\n\n";
}




//ROMAN TO ARABIC FUNCTION
void RomantoArabic()
{
	int ArabicLookup[8] = {1000, 500, 100, 50, 10, 5, 1},
		Arabic[15] = {0};
	char  RomanLookup[8] = {"MDCLXVI"},
        Roman[15] = {0};
	int i, len, j, sum = 0;
	
	cout << "\nPlease enter a Roman Numeral: ";
	cin  >> Roman;
	
	len = strlen(Roman);
	
	for (i = 0; i < len; i++)
	{
		for (j= 0; j < 7; j++)
		{
			if (Roman[i] == RomanLookup[j])
				Arabic[i] = ArabicLookup[j];
		}
		
	}
	
	for (i = 0; i < len; i++)
	{
		if (Arabic[i] >= Arabic[i+1])
			sum += Arabic[i];
		else
			sum -= Arabic[i];
	}
	
	cout << "\nThe Roman Numeral in Arabic is "
		<< sum << ".\n\n";
	
}

