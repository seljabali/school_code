//Program #3 Easter Sunday
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

  int n, na, nb,
      nc, nd, ne,
     i, date;

  fstream infile ("C:\\DOCUMENTS AND SETTINGS\\DEFAULT\\DESKTOP\\Dates.dat", ios::in);

  for (i=0; i<2; i++)
  {
    infile >> n;
    na = n % 19;
    nb = n % 4 ;
    nc = n % 7;
    nd = (19 * na + 24) % 30 ;
    ne = ( 2 * nb + 4 * nc + 6 * nd + 5) % 7;
   
    date = 22 + nd + ne;

    if (date > 31)
    {
      date = date - 31;
      cout << "Easter Sunday in year " << n << " is in April " << date;
    }
    else 
      cout << "Easter Sunday in year " << n << " is in March " << date;
    
    cout << "\n" << "\n";
  }

  cout << "Press any key to continue";
  cin.get();

  return 0;

}
  