//Name: Sami Eljabali
//Program 20

#include <iostream>

using namespace std;

int Calculate(int n);

int main()
{
  int answer = 1, Index;

  cout << "Please enter a Fibonacci number: ";
  cin >> Index;

  answer = Calculate(Index);

  cout << "\nThe Fibonacci number is " << answer << ".";

  cin.get();
  cin.get();
  return 0;
}

int Calculate(int n)
{
  if (n <= 1)
    return n;
  else 
  {
    return (Calculate(n-1) + Calculate(n-2));
  }
}