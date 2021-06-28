//Program #7 Calculating Julian dates
//Name: Sami Eljabali
//Class: CS265-82
//Date: 7/5/04


#include <iostream>

using namespace std;

int main()
{
	int day, year, month2, i, julian,
		month[12] = {31, 28, 31, 30,
					 31, 30, 31, 31,
					 30, 31, 30, 31};
	char YorN = 'y';

	while (YorN == 'y')
	{
		
		day = year = month2 = i = julian = 0; 

		cout << "Enter a date [mm dd yyyy]: ";
		cin >> month2 >> day >> year;
		cout << endl;

		if ((year % 4) == 0)
			month[1] = 29;
		else 
			month[1] = 28;

		for (i = 0; i < month2 - 1; i++)
			
			julian += month[i];
		
		julian += day;

		cout << "The Julian date is " << julian << "\n\n"
			 << "Do you want to continue?[y or n]  ";
		cin >> YorN;
		cout << endl;
		
	}
	

	cin.get();
	return 0;
}