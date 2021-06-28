//Name: Sami Eljabali 
//Program 19

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct record
{
  char name[15];
  double amt;
};

int findSmallest(record *p[], int top, int n);
int findSmallString(record *p[], int top, int n);

int main()
{
  ifstream fin;
  
  fin.open("Trans.dat", ios::binary);
  fin.seekg(0, ios::end);
  long lastByte = fin.tellg();
  int n = lastByte/sizeof(record);
  
  record *trans = new record[n];
  record **ptr = new record*[n];
  
  fin.seekg(0, ios::beg);
  for (int i = 0; i < n; i++)
  {
    fin.read((char *)&trans[i], sizeof(record));
  }
  cout << "Unsorted: \n";
  /*Before Sorting*/
  for (i = 0; i < n; i++)
  {
    ptr[i] = &trans[i];
    cout << ptr[i]->name << '\t' << ptr[i]->amt << endl;
  }
  
  cout << endl;

  /*Sorting By Amount*/
  for (i = 0; i < n; i++)
  {
    int smallestSub = findSmallest(ptr, i, n);
    record* temp = ptr[i];
    ptr[i] = ptr[smallestSub];
    ptr[smallestSub] = temp;
  }
  
  cout << "Sorted by Amt: \n";
  for (i = 0; i < n; i++)
  {
    cout << ptr[i]->name << '\t' << ptr[i]->amt << endl;
  }

 cout << "\nSorted by Name: \n";

  /*Sorting By Name*/
  for (i = 0; i < n; i++)
  {
    int smallSub = findSmallString(ptr, i, n);
    record* tem = ptr[i];
    ptr[i] = ptr[smallSub];
    ptr[smallSub] = tem;
  }
  
  for (i = 0; i < n; i++)
  {
    cout << ptr[i]->name << '\t' << ptr[i]->amt << endl;
  }

  cin.get();
  return 0;
}

/*Functions*/
int findSmallest(record *p[], int top, int n)
{
  int smallSub = top;
  double small = p[top]->amt;
  for (int i = top + 1; i < n; i++)
  {
    if (p[i]->amt < small)
    {
      small = p[i]->amt;
      smallSub = i;
    }
  }
  return smallSub;
}

int findSmallString(record *p[], int t, int n)
{
  int smallSub = t;
  char small[15];
  strcpy(small, p[t]->name);
  for (int i = t + 1; i < n; i++)
  {
    if ((strcmp(p[i]->name, small)) < 0)
    {
      strcpy(small, p[i]->name);
      smallSub = i;
    }
  }
  return smallSub;
}

