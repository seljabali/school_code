//Program #8 Calculating Julian dates
//Name: Sami Eljabali
//Class: CS265-82
//Date: 7/5/04


#include <iostream>
#include <fstream>

using namespace std;

int main()
{
	int day, year, i, julian, month2,
	  	month[12] = {31, 28, 31, 30,
					 31, 30, 31, 31,
					 30, 31, 30, 31};
	char YorN = 'y',
		 mon[15], str[256];

    fstream outfile ("c:\\prog8.dat", ios::out);

	while (YorN == 'y')
	{
		//Initializing
		day = year = i = month2 = julian = 0;

		//Input
		cout << "Enter a date [MONTH dd yyyy]: ";
		cin >> mon >> day >> year;
		cout << endl;

		//Determing if the year is a lepear
		if ((year % 4) == 0)
			month[1] = 29;
		else
			month[1] = 28;

		//Converting Month to a #
		if (strcmp(mon,"January") == 0)
			month2 = 1;

		else if (stricmp(mon,"February") == 0)
			month2 = 2;

		else if (stricmp(mon,"March") == 0)
			month2 = 3;

		else if (stricmp(mon,"April") == 0)
			month2 = 4;

		else if (stricmp(mon,"May") == 0)
			month2 = 5;

		else if (stricmp(mon,"June") == 0)
			month2 = 6;

		else if (stricmp(mon,"July") == 0)
			month2 = 7;

		else if (stricmp(mon,"August") == 0)
			month2 = 8;

		else if (stricmp(mon,"September") == 0)
			month2 = 9;

		else if (stricmp(mon,"October") == 0)
			month2 = 10;

		else if (stricmp(mon,"November") == 0)
			month2 = 11;

		else if (stricmp(mon,"December") == 0)
			month2 = 12;


		//Calculating the Julian date
		for (i = 0; i < month2 - 1; i++)

			julian += month[i];

		julian += day;


		//Writing to file
		outfile << mon << " " << day << ", "
                << year << "   "  << "Julian date = "
                << julian << "\n";

		//Continue question
	  cout << "Do you wish to continue?[y or n]  ";
	  cin >> YorN;
	  cout << endl;

	}

    outfile.close();

	//Reading from file
	fstream infile ("c:\\prog8.dat", ios::in);

    while (infile.getline(str, 256, '\n'))

      cout << str << endl;


    cin.get();
    cin.get();
	return 0;
}



