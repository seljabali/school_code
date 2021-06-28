//File:         se_bodyparts.cpp
//Purpose:      The program will display a diagram of a male and a female
//Author:       Sami Eljabali
//Date:         09/29/2003
//Input:        Nothing
//Output:       Display a diagram of a male and a female
//Description:
//
//              Male
//              Call the head function
//              Call the arms function
//              Call the malebody function
//
//              Female
//              Call the head function
//              Call the arms function
//              Call the femalebody function

#include<iostream>
#include<iomanip>
#include<string>

using namespace std;

//Declaring functions
void head();
void arms();
void malebody();
void femalebody();

int main()
{

  cout << "THE FEMALE BODY:" << endl << endl;
  //Forming Femalebody
  head();
  arms();
  femalebody();

  cout << endl << endl;

  cout << "THE MALE BODY:" << endl << endl;
  //Forming Male body
  head();
  arms();
  malebody();


  cin.get();

  return 0;

}

//Head function
void head()
{

  cout << setw(7) << "*" << endl;
  cout << setw(5) << "*" << setw(4) << "*" << endl;
  cout << setw(6) << "*" << setw(2) << "*" << endl;

}

//Arms function
void arms()
{

  cout << "---------------" << endl;

}

//Malebody function
void malebody()
{

  cout << setw(7) << "|" << endl;
  cout << setw(7) << "|" << endl;
  cout << setw(7) << "|" << endl;
  cout << setw(7) << "|" << endl;

}

//Femalebody function
void femalebody()
{

  cout << "     /  \\" << endl;
  cout << "    /    \\" << endl;
  cout << "   /      \\" << endl;
  cout << "  /________\\" << endl << endl;

}

