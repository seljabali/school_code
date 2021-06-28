//Name: Sami Eljabali 
//Program 13: Character Reader

#include <iostream>
#include <fstream>

using namespace std;

int main()
{
  
  fstream outfile("Prog13.dat", ios::out);
  
  outfile << "   Roses are    !@#$% red    \n"
          << "Violets are blue\n"
          <<"Pansy's  smell good  too  \n"
          << "\n";

  cout << "Files have been written!";
  cin.get();
  return 0;
}