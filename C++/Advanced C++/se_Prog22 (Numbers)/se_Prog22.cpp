 //Name: Sami Eljabali
//Program 22 Number program

#include <iostream>

using namespace std;

void pronounce(long int temp, int type);
int main()
{
  char ans = 'y';

  while (ans == 'y')
  {
    long int num = 0, m = 0, t = 0, h = 0,tens = 0;
	  int type = 0;

    cout << "Welcome to the Number program!!\n";
    cout << "Please enter a number: ";
    cin  >> num; cout << endl;

    if (num < 0)
    {
      num = num * -1;
      cout << "Negative ";
    }

    /*10^6*/
	  m = num / 1000000;
    if (m != 0)
    {
	    type = 1;
      pronounce(m, type); 
      m *= 1000000;
	    num -= m;
    }

    /*10^3*/
    t = num / 1000;
    if (t != 0)
    {	  
	    type = 2;
      pronounce(t, type);
      t *=  1000;
      num -= t;
    }

    /*10^2*/
    if (num != 0)
    {	 
      type = 0;
      pronounce(num, type);
    }

    cout << "\n\nDo you wish to continue?[y/n] ";
    cin  >> ans;
    cout << endl;
  }

  cin.get();
  return 0;
}
void pronounce(long int temp, int type)
{
	
  int hundreds, tens, digit, mark;
  hundreds = tens = digit = mark = 0;

  char *one[10]  = {"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"};
  char *teen[10] = {"Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", 
                    "Eighteen", "Nineteen"};
  char *ten[10]  = {"Ten", "Twenty", "Thirty", "Fourty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"};

  if ( temp != 0 && ((temp / 100) != 0 ) )
  {
    hundreds = temp / 100;
    cout << one[hundreds] << " ";
    cout << "hundred ";
    temp = temp - (hundreds * 100);
  }
  
  if ( temp != 0 && ((temp / 10) != 0))
  {
    tens = temp / 10;
    
    if ( tens > 1 )
    {
      cout << ten[tens - 1] << " ";
    }
    
    if ( tens == 1 && ((temp % 10) == 0))
    {
      cout << ten[0] << " ";
    }

    if ( tens == 1 && ((temp % 10) != 0))
    {
      cout << teen[(temp % 10) - 1];
      mark = 1;
    }
    temp = temp - (tens * 10);
  }
  
  if ( (temp != 0) && mark !=1 )
  {
    digit = temp;
    cout << one[digit];
  }
  
  if (type == 1)
    cout << " Million \n";
  else if (type == 2)
    cout << " Thousand \n";
  else if (type == 3)
    cout << " Hundred \n";
}