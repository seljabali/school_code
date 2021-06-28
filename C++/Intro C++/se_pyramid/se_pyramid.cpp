/***************************************************************************
	        FILE:         se_pyramid.cpp
	        AUTHOR:       Sami Eljabali
			DATE:         10/21/2003
			INPUT:        Any letter from the keyboard
			OUTPUT:       To display the letters from A to the entered letter
						  then to display that letter to the letter A
****************************************************************************/

#include <iostream>
#include <cctype>
#include <iomanip>
using namespace std;

int main()
{
  char ch,        //Input
       ch2 = 'A'; //Tester
  
  int width = 25, //Setting Width
	  temp;	      //Temporary Variable
  
  //Input
  cout << "Please enter a letter: ";
  cin >> ch;
  ch = toupper(ch);
  cout << endl;
  //Displaying "A"
  cout << setw(26) << 'A' << endl;

	for (temp = 2; temp <= ch - 64; temp++)
    {
	  cout << setw(width);

      //Acending
      for (ch2 = 'A'; ch2 <= 64 + temp; ch2++)
        cout << ch2;
  
      //Decending
      for (ch2 = ch2 - 2; ch2 >= 65; ch2--)
        cout << ch2;

	  width--;
      cout << endl;
    }
  
  cin.get();
  cin.get();
  return 0;
}
