//Program #5 Grade Average
//Name: Sami Eljabali
//Class: CS265-82
//Date: 6/29/04


#include <iostream>
using std::cin;
using std::cout;
using std::endl;

void Input(int &ID, float &grade, float &grade2, float &grade3);
void Average(float &grade, float &grade2, float &grade3, float &average);
void Output(int &ID, float &grade, float &grade2, float &grade3, float &average);

int main()
{
  int ID;
  char YorN = 'y';
  float grade, grade2, grade3, average;


  while (YorN == 'y')
  {

    cout << "Please enter your student ID and three grades: ";
  
    Input(ID, grade, grade2, grade3);
  
    Average (grade, grade2, grade3, average);
  
    Output (ID, grade, grade2, grade3, average);

    cout << "\n Do you want to continue?[y or n] ";
    cin >> YorN;
    cout << "\n\n";
  }
  
 cin.get();
 return 0;

}


void Input(int &ID, float &grade, float &grade2, float &grade3)
{
  cin >> ID >> grade >> grade2 >> grade3;
}

void Average(float &grade, float &grade2, float &grade3, float &average)
{

  average = ((grade + grade2 + grade3) / 3);

}

void Output(int &ID, float &grade, float &grade2, float &grade3, float &average)

{
  int i;

  cout << "\n ID " << ID << " " << "Scores " << grade << ", "
       << grade2 << ", " << grade3 << ", " << "   "
       << "Average = " << average;
  cout << "\n ID " << ID << " ";

  for (i = average; i > 0; i--)
    cout << "*";

}
 