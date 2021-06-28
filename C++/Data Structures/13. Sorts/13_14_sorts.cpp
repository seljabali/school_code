#include <iostream.h>

void mergeit (double x [] , int n1, int n2 );
void rmergeSort (double data [], int n);

void rmergeSort (double data [], int n)
{
  if ( n == 1) //base case
  {
    return;

  }
  else //recursive case
  {
     //This code is exercise in the forward path (recursion’s head path).
     //In this part, we divide up the original array 
     //into two arrays: one of length n1 the other of length n2.
     //Then we call this method recursively which has the effect
     //of each of the array being re-divided into two again.
     //We do this recursively until the length of the array becomes 1 
     //which is the base case shown above.
     int n1 = n/2;
     int n2 = n - n1;

     rmergeSort (data, n1);
     rmergeSort (data+n1, n2);

     //This code is exercised on return path (recusion’s tail path).
     //When we arrive here, the code has returned from the above two calls.
     //Which means that mergeit has been called on each part of the array.  
     //So both parts of the array are individually sorted. 
     //Now merge the two parts.
     
     mergeit (data, n1, n2);
     
     //When we return from here.
     //The caller of this routine (i.e. the caller of rmergeSort)
     //will receive a sorted array.
  }
  

}

//This method receives an array made up of two parts
//which are individually sorted.
//It will merge them in a single sorted array
void mergeit (double x [] , int n1, int n2 )
{
  int n = n1 + n2;
  //Create a temporary array
  double * temp = new double [ n ];
  //The array received contains two arrays.
  //Setup two pointers to the array received.
  //One pointing to the first array and the other to the second array.
  //Also set up two indices. 
  //One index for the first array and the other for the second array.
  //Also set up an index to the temporary array.

  double * p1 = x;
  double * p2 = x + n1;
  
  int i1 = 0; //index for the first array
  int i2 = 0; //index for the second array
  int i =  0; //index for the temporary array.

  //Start Mergeing
  while ( !  ( (i1>= n1 ) || (i2 >= n2) )   )
  {
    if (p1 [i1] < p2 [i2] )
    {
      temp [i] = p1 [i1];
      i1++;
      i++;
    }
    else
    {
      temp [i] = p2 [i2];
      i2++;
      i++;
    }
  }
  //something left of the first array to copy
  while ( i1 < n1)
  {
    temp [i] = p1 [i1];
    i1++;
    i++;
  }
  //something left of the second array to copy
  while (i2 < n2 )
  {
    temp [i] = p2 [i2];
    i2++;
    i++;
  }

  //copy the temporary array back into original array
  for (int j=0;j < n ; j++)
  {
    x [j] = temp[j];
  }

}

void main ( )
{
  //original unsorted array.
  double data [] = {7, 3, 5, 1, 8, 4, 6, 2};
  
  //sort array
  rmergeSort (data, 8);
  
  //Array sorted. Display its contents.
  for (int i= 0; i< 8; i++)
  {
    cout << data[i] << " ";
  }
  cout <<endl;

}







