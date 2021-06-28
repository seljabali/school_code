//Name: Sami Eljabali
//Program 13b Reading characters

#include <iostream>
#include <fstream>

using namespace std;

#define False 0
#define True 1

int ckspace(char ch);

void main()
{
  char arr[80] = {0}, ch = '0';
  int TorF = 0,spstate, wordstate, len, 
	  i, charcount, spacecount, wordcount;

  spstate = wordstate = len = i = charcount = spacecount = wordcount = 0;
  fstream infile("Prog13.dat", ios::in);

  ckspace(ch);

  infile.getline(arr, 80);

  while (!infile.eof())
  {
	i = 0;
    spstate = True;
    wordstate = False;
    len = strlen(arr);
    arr [len] = '\n';
    len++;wordcount++;

    while (i < len)
    {
      if (spstate && (arr[i] == ' ' || arr[i] == '\n'))
      {
        i++;
		spacecount++;
      }
      else
      {
        spstate = False;
		wordstate = True;
		charcount++;
		i++;

      }
	spstate = True;
    wordstate = False;
    }
	infile.getline(arr, 80);
  }
  cout << "Number of spaces are " << spacecount << endl;
  cout << "Number of characters are " << charcount << endl;
  cout << "Number of words are " << wordcount;
  cin.get();
}


int ckspace(char ch)
{
  int TorF;

  if (ch == ' ')
    TorF = 1;
  else
    TorF = 0;
  
  return TorF;
}