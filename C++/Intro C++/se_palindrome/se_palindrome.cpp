/************************************************************************************************
            FILE:          se_palindrome.cpp
            AUTHOR:  Sami Eljabali
            PURPOSE: To read in a word then determine if it a palindrome word or not.
            DATE:        11/12/2003
            INPUT:      A word which consists with not more that 10 letters
            OUTPUT:  Display of whether the word is a palindrome or not.
*************************************************************************************************/
#include <iostream>
#include <cstring>
using namespace std;

int main()
{
    char YorN = 'y',
         word[11],
         revWord[11];
 
  while(YorN == 'y')
  {
	 system("cls");//Clears screen for each new input

     //Input
     cout << "Please enter a word to see if it a palindrome or not: ";
     cin.get( word, 10 );
	 
     //Copying then Reverse
     strcpy(revWord, word);
     strrev(revWord);
    
    //Comparing
    if( strcmp( word, revWord ) != 0)
    {  
        cout << endl << "It's not a palindrome word!" << endl  << endl;
        cin.get();
    }
    else
    {
        cout << endl << "It's a palindrome word!" << endl << endl;;
        cin.get();
    }
    
    //If user want to continue
    cout << "Do you want to continue? (y or n): ";
    cin >> YorN;
    
    cout << endl << endl;
 
    cin.get();
  }
  return 0;
}
