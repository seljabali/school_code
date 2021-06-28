//Program #1 Sample Program
//Name: Sami Eljabali
//Class: CS265-82
//Date: 6/28/04

#include <fstream>
using std::fstream;
using std::ios;
#include <iostream>
using std::cin;
using std::cout;
using std::endl;


int main()
{
  fstream outfile ("prog1.dat", ios::out);
  
  int i,
      num;

  for ( i = 0; i < 3; i++)
  {

    cout << "\nEnter a one digit number: ";
    cin >> num;
    outfile << num << endl;
  }

  outfile.close();

  fstream infile ("prog1.dat", ios::in);

  cout << "\n\nYou wrote the following 3 numbers on the disk: \n\n";
  
  for ( i = 0; i < 3; i++)
  {

    infile >> num;
    cout << num << endl;

  }

  cin.get();
  cout << "\n Press any key to exit";
  cin.get();

  return 0;
}