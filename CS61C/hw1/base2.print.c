/*

   Name: Sami Eljabali

   Lab Login: cs61c-by

*/

#include <stdio.h>

int main ( ) {

   unsigned int numToPrintInBase2 = 1431655765; /* alternating 1?s and 0?s */

   unsigned int exp = 1;

   int k;  /* can't declare variable in a loop header */

 

   /* Compute the highest storable power of 2 (2 to the 31th). */

   for (k=0; k<31; k++) {

     exp = exp * 2;

   }

   /* For each power of 2 from the highest to the lowest,

     print 1 if it occurs in the number, 0 otherwise. */

   for (k=31; !(k==0); k--) {

     if (numToPrintInBase2 >= exp) {

        printf ("%d", 1);

        numToPrintInBase2 = numToPrintInBase2 - exp;

     } else {

        printf ("%d", 0);

     }

     exp = exp / 2;

   }

   printf ("\n");

   return 0;

}
