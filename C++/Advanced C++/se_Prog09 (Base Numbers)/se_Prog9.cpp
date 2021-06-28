//Program #9 Converting Base numbers
//Name: Sami Eljabali
//Class: CS265-82
//Date: 7/6/04


#include <iostream>
#include <cmath>

using namespace std;

int main()
{
  char values[16] = {'0','1','2','3','4','5','6','7','8','9',
    'A','B','C','D','E','F'},
    YorN = 'y',
    num2[50] = {0};

  int newbase = 0,
    oldbase = 0,
    sum = 0,
    i = 0, j = 0,
    num[50] = {0},
    remainder[50] = {0},
    len = 0;

  while ((YorN == 'y') || (YorN == 'Y'))
  {
    //Input
    cout << "Enter a number you wish to convert: ";
    cin  >> num2;

    cout << "\n\nEnter its base: ";
    cin  >> oldbase;

    cout << "\n\nEnter the base you want to convert it to: ";
    cin  >> newbase;

    len = strlen(num2);


    //Converting chr to int vaules
    for (i = 0; i < len; i++)
    {
      if (isdigit(num2 [i]))

        num[i] = num2[i] - 48;

      else

        num[i] = num2[i] - 55;
    }

    //Converting Base x to Base 10
    for (j = 0, i = len -1; i >= 0; j++, i--)

      sum += ((pow(oldbase, i)) * num[j]);

    i = 0;

    //Converting base 10 to Base y
    do
    {
      remainder[i] = sum % newbase;
      sum = sum / newbase;
      i++;
    } while (sum != 0);


    //Output
    cout << "\n\nNumber in the new base is ";

    for (j = i - 1; j > -1; j--)

      cout << values[remainder[j]];

    cout << "\n\nDo you wish to continue?[y/n] ";
    cin  >> YorN;
    cout << endl;
  }

  return 0;
}







