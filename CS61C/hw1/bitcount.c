/*

   Name: Sami Eljabali

   Lab Login: cs61c-by

*/

#include <stdio.h>

int bitCount (unsigned int n);

int main ( ) {

   printf ("# 1-bits in base 2 rep of %u = %d, should be 0\n",

     0, bitCount (0));

   printf ("# 1-bits in base 2 rep of %u = %d, should be 1\n",

     1, bitCount (1));

   printf ("# 1-bits in base 2 rep of %u = %d, should be 16\n",

     1431655765, bitCount (1431655765));

   printf ("# 1-bits in base 2 rep of %u = %d, should be 1\n",

     1073741824, bitCount (1073741824));

   printf ("# 1-bits in base 2 rep of %u = %d, should be 32\n",

     4294967295, bitCount (4294967295));

   return 0;

}

/* Your bit count function goes here. */
int bitCount (unsigned int n)
{
    int k = 0, counter = 0;
    unsigned int exp = 1;

    for (k=0; k<31;k++)
    {
	exp = exp *2;
    }
    for (k=31; k>=0; k--)
    {
	if (n >= exp)
	{
	    n = n - exp;
	    counter++;
	}
	exp = exp / 2;
     }
    return counter;
}
