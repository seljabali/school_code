//Program 12 Calculating differences of days
//Name: Sami Eljabali
//Date 7/13/04

#include <iostream>

using namespace std;

struct date
{
  int m,d,y;
};

long CalcN(date &day);
long Calcf(date &day);
long Calcg(date &day);
void DatePrint(date day1, date day2);

char   week[7][15] = {"Sunday", "Monday", "Tuesday", "Wednesday",
                      "Thursday", "Friday", "Saturday"},

       month[12][15] = {"Janurary", "Feburary", "March", "April",
                        "May", "June", "July", "August", "September",
                        "October", "November", "December"};
int main()
{

  date day1, day2;

  char YorN = 'y';
  long Nday1, Nday2, Diff;


  cout << "Welcome to the date calculation!!";

  while (YorN == 'y')
  {
    cout << "\n\nPlease enter two dates to calculate their differnce.\n\n"
         << "In this format [mm][dd][yyyy]: ";
    cin  >> day1.m >> day1.d >> day1.y;

    cout << "\nIn this format [mm][dd][yyyy]: ";
    cin  >> day2.m >> day2.d >> day2.y;

    DatePrint(day1, day2);

    Nday1 = CalcN(day1);
    Nday2 = CalcN(day2);
    Diff  = Nday2 - Nday1;

	  cout << "The difference between them is " << Diff << " days.";

    cout << "\nDo you wish to continue?[y/n] ";
    cin  >> YorN;
  }

  cin.get();
  return 0;
}

void DatePrint(date day1, date day2)
{
  long N1, N2, day3, day4;

  N1 = CalcN(day1);
  N2 = CalcN(day2);

  day3 = (N1 - 621049) % 7;
  day4 = (N2 - 621049) % 7;

  cout << "\n" << month[day1.m - 1] << " "
       << day1.d << ", " << day1.y
	     << " which would be a " << week[day3]
	     << endl;

  cout << "\n"<< month[day2.m - 1]
	     << " " << day2.d << ", " << day2.y
	     << " which would be a " << week[day4]
	     << endl << endl;
  

}

long CalcN(date &day)
{
  long N;

  N = 1461 * Calcf(day)/ 4 + 153 * Calcg(day)/ 5 + day.d;

  return N;
}

long Calcf(date &day)
{

  if (day.m < 3)
    day.y--;
  else
    day.y = day.y;

  return day.y;
}

long Calcg(date &day)
{
  if (day.m < 3)
    day.m += 13;
  else
    day.m += 1;

  return day.m;

}

 