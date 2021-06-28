/*************************************************************************************************
  
			FILE:			se_convert.cpp
			AUTHOR:			Sami Eljabali
			DATE:			10/22/2003
			INPUT:			Letters, numbers and decimal point somewhere in the middle of it
			OUTPUT:			The numbers before the decimal point combined to one number
							The numbers after the decimals are combined. then the program
							would display both number combined as the second part a decimal
*************************************************************************************************/


#include<iostream>
#include<cctype>
#include<cmath>

using namespace std;

int main()
{
  char ch;

  int sumA = 0,
      sumB = 0,
      counter = 0;

  float num = 0.00,
        result = 0.00,
		A = 0.00,
		B = 0.00;

  //Input
  cout << "Please enter a decimal number with mixed letters in it: ";
  cin.get(ch);
  cout << endl;

  //Reading First Half Before '.'
  while (ch !='.')
  {
    if (isdigit(ch))
    {
      num = int(ch - '0');
      sumA = sumA * 10 + num;
    }

    cin.get(ch);
  }

  cin.get(ch);

  //Reading Second Half Before '\n'
  while (ch !='\n')
  {
    if (isdigit(ch))
    {
      counter++;
      num = int(ch - '0');
      sumB = sumB * 10 + num;
    }
    
    cin.get(ch);
  }

  //Output
  A = sumA; //Converting integers to floating points for calculations
  B = sumB;
  
  result = A + (B / (10 ^ counter));
  
  cout << A << "  " << B << "    " << result;

cin.get();
return 0;
}