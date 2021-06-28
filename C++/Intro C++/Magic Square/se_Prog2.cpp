//Program #2 Magic Square Program
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
  int x = 0,
      y = 0,
      z = 0,
      row = 0,
      col = 0,
      temp = 0,
      arr[3][3] = { 0, 0, 0,
                    0, 0, 0,
                    0, 0, 0 };


  fstream infile ("C:\\DOCUMENTS AND SETTINGS\\DEFAULT\\DESKTOP\\prog1.dat", ios::in);

  infile >> x;
  infile >> y;
  infile >> z;


  arr[0][0] = x-z;
  arr[0][1] = x-y+z;
  arr[0][2] = x+y;
  arr[1][0] = x+y+z;
  arr[1][1] = x;
  arr[1][2] = x-y-z;
  arr[2][0] = x-y;
  arr[2][1] = x+y-z;
  arr[2][2] = x+z;

  for (row = 0; row < 3; row++)
  {
    for (col = 0; col < 3; col++)
      cout << arr[row][col] << "  ";
    
    temp = 3 % col;
    
    if (temp == 0)
        cout << endl;
  }


  cin.get();
  cout << "\n Press any key to exit";
  cin.get();

  return 0;
}