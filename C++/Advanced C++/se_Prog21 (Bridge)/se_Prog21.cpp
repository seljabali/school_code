//Name: Sami Eljabali
//Program 21 Bridge

#include <iostream>
#include <time.h>
#include <cstdlib>

using namespace std;

void Gen(int hand[13], int cards[52]);
int sort_fun(const void *f, const void *s);

int main()
{
	char ans = 'y';
	while (ans == 'y')
	{
		int points = 0, hand[13] = {0}, cards[52] = {0},
		    spade = 0, heart = 0, club = 0, diamond = 0,
		    i = 0;
		
		/*unsorted*/
		cout << "Welcome to the Hand Bridge Generator!!\n\n";
		cout << "Unsorted hand is:\n";
		Gen(hand,cards);
		
		/*sorted*/
		cout << "\n\nSorted hand is:\n\n";
		qsort((void *)hand, 13, sizeof(hand[0]), sort_fun);
		
		/*Printing*/
		for (i = 0; i < 13; i++)
		{
			if (hand[i] > 1 && hand[i] < 14)
				spade++;
			else if (hand[i] > 14 && hand[i] < 26)
				heart++;
			else if (hand[i] > 26 && hand[i] < 38)
				diamond++;
			else if (hand[i] > 38 && hand[i] < 52)
				club++;
		}

		if (spade != 0)
		{
			cout << "Spades: ";
			for (i = 0; i < 13; i++)
			{
				if (hand[i] > 1 && hand[i] < 10)
				{
					cout << hand[i] << " ";
				}
				else if (hand[i] == 10)
				{
					cout << "J ";
					points++;
				}
				else if (hand[i] == 11)
				{
					cout << "Q ";
					points += 2;
				}
				else if (hand[i] == 12)
				{
					cout << "K ";
					points += 3;
				}
				else if (hand[i] == 13)
				{
					cout << "A ";
					points += 4;
				}
			}
		}
	    if (heart != 0)
		{
			cout << "Hearts: ";
			for (i = 0; i < 13; i++)
			{
				if (hand[i] > 14 && hand[i] < 22)
				{
					cout << hand[i] % 13 << " ";
				}
				else if (hand[i] == 23)
				{
					cout << "J ";
					points++;
				}
				else if (hand[i] == 24)
				{
					cout << "Q ";
					points += 2;
				}
				else if (hand[i] == 25)
				{
					cout << "K ";
					points += 3;
				}
				else if (hand[i] == 26)
				{
					cout << "A ";
					points += 4;
				}
			}
		}
	    if (diamond != 0)
		{
			cout << "Diamonds: ";
			for (i = 0; i < 13; i++)
			{
				if (hand[i] > 27 && hand[i] < 35)
				{
					cout << hand[i] % 13 << " ";
				}
				else if (hand[i] == 36)
				{
					cout << "J ";
					points++;
				}
				else if (hand[i] == 37)
				{
					cout << "Q ";
					points += 2;
				}
				else if (hand[i] == 38)
				{
					cout << "K ";
					points += 3;
				}
				else if (hand[i] == 39)
				{
					cout << "A ";
					points += 4;
				}
			}
		}
	    if (club != 0)
		{
			cout << "Clubs: ";
			for (i = 0; i < 13; i++)
			{
				if (hand[i] > 40 && hand[i] < 48)
				{
					cout << hand[i] % 13 << " ";
				}
				else if (hand[i] == 49)
				{
					cout << "J ";
					points++;
				}
				else if (hand[i] == 50)
				{
					cout << "Q ";
					points += 2;
				}
				else if (hand[i] == 51)
				{
					cout << "K ";
					points += 3;
				}
				else if (hand[i] == 52)
				{
					cout << "A ";
					points += 4;
				}
			}
		}
		/*points*/
		cout << "\n\nThere are " << points << " points in this hand.\n";
		
		/*continue*/
		cout << "\nWould you like to continue?[y\\n] ";
		cin  >> ans;
		system("cls");
	}
	cin.get();
	return 0;
}

/****FUNCTIONS****/

/*generator*/
void Gen(int hand[13], int cards[52])
{
  int i = 0, n = 0; 

  srand((unsigned)time(NULL));
  while (i < 13)
  {
    n = ("%d",rand()) % 52 + 1;
    if (cards[n] == 0)
    {
      hand[i] = n;
      cards[n]++;
      i++;
	  if (i == 13) cout << n;
	  else cout << n << ", ";
    }
  }
}

/*UDF*/
int sort_fun(const void *f, const void *s)
{
	int x = 0;
		
	if (*(char *) f > *(char *) s)
		x = 1;
	else if (*(char *) f < *(char *) s)
		x = -1;
		
	return x;
}
