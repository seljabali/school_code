//Program #6 Approximating e^x
//Name: Sami Eljabali
//Class: CS265-82
//Date: 6/29/04


#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

double factorial(double);

int main()
{
  double x, top, bottom, term, sum;
  int i = 0;
  char YorN = 'y';

  x = top = bottom = term = sum = 0;
  
   


  while (YorN == 'y')
  {
    i = 0;
    cout << "Please enter a number to approximate its base e^: ";
    cin >> x;
    cout << endl;
  
    cout << "Iteration" << setw(9) << "Term" << setw(13)
         << "Value" << "       " << "Approx. of e to x power"
         << endl << endl;
    while ((pow(x,i)/factorial(i)) > 0.001) 
    {
      top = pow(x,i);
      bottom = factorial(i);
      term = top/bottom;
      sum += term;
      ++i;
      cout.setf(ios::showpoint);
      cout.setf(ios::fixed, ios::floatfield);


      cout << setprecision (3) << " " << setw(2) << i << "         " << "x^" 
		   << setw(2) << i-1 << "/" << setw(2) << i-1 << "!" 
		   << "       " <<  setw(2) << term << "        " << setw(2)
           << sum << endl; 

    }   

    cout << "\nDo you want to continue?[y or n] ";
    cin >> YorN;
    cout << endl;


  }

  cin.get();
  return 0;
}


double factorial(double x)
{

  double facc = 1.0;
    while (x > 1)
    {
      facc *= x;
      x--;
    }
  return facc;
}

