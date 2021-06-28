//Program #4 Calculator
//Name: Sami Eljabali
//Class: CS265-82
//Date: 6/29/04


#include <iostream>
using std::cin;
using std::cout;
using std::endl;


int main()
{

  float num, num2, answer;
  char op, YorN = 'y';

  while (YorN == 'y')
  {
    cout << "Please enter a math problem: ";
    cin >> num >> op >> num2;
    switch (op)
    {
        case '+': answer = num + num2;
                  break;
        case '-': answer = num - num2;
                  break;
        case '*': answer = num * num2;
                  break;
        case '/': answer = num / num2;
                  break;
        default:  cout << "Please add, subtract, multiply, or divide two numbers.";

    }

    cout << "\n\n" << num << " " << op << " " << num2 << " is " << answer;

    cout << "\n\nDo you want to continue?[y or n] ";
    cin >> YorN;
    cout << endl;

  }

cin.get();
return 0;
}





