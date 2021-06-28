/*
 * Name: Sami Eljabali
 * Class: 61c
 * HW #2
 */
#include <stdio.h>
unsigned int conv_binary(unsigned int);
unsigned int char_to_int(char[]);
int pow(int base, int n);

int main()
{
  int  length, num_solutions, pushes;
  unsigned int Lights, solution, i, i2, test, temp;
  char InitialState[10];

  Lights = i = i2 = solution = test = temp =  0;
  length = num_solutions = pushes  = 0;
  
     
  /*INPUT*/
  printf("%s","Please enter by row major a 3x3 matrix:\n");
  scanf("%s",InitialState);

  Lights = char_to_int(InitialState);
  
  for(i = 0; i < 512; i++)
  {
    i2 = conv_binary(i);
    Lights = char_to_int(InitialState);
    solution = 0;
    pushes = 0;

    /* printf("%s%u%s%u%s%u%s%u\n", "I: ",i2," 255: ", conv_binary(255)," i^255 = ",i2 ^ conv_binary(255), " should = ", conv_binary(256));*/

    /*Does this combination have the button 1 pressed?*/
    if (i2 >> 8 == 1)
    {
      printf("%s", "Button1");
      pushes++;
      Lights =(Lights ^ conv_binary(420)); /*yes, therefore, press 1*/
    }
    else if(i2 >> 7  == conv_binary(128))
    {
      printf("%s", "Button2");
      pushes++;
      Lights = (Lights ^ conv_binary(466));
    }
    else if(i2 >> 6  == conv_binary(64))
    {
      printf("%s", "Button3");
      pushes++;
      Lights = (Lights ^conv_binary(201));
    }
    else if (i2 >> 5  == conv_binary(32))
    {
      pushes++;
      Lights = (Lights ^ conv_binary(308));
    }
    else if (i2 >> 4 == conv_binary(16))
    {
      pushes++;
      Lights = (Lights ^ conv_binary(186));
    }
    else if (i2 >> 3 == conv_binary(8))
    {
      pushes++;
      Lights = (Lights ^ conv_binary(294));  
    }
    else if(i2 >> 2  == conv_binary(4))
    {  
      pushes++;
      Lights = (Lights ^ conv_binary(294));  
    }
    else if (i2 >> 1 == conv_binary(2))
    {
      pushes++;
      Lights = (Lights ^conv_binary(151));    
    }
    else if(i2 >> 0 == conv_binary(1))
    {
      pushes++;
      Lights = (Lights ^conv_binary(75));
    }
    if (conv_binary(Lights) == conv_binary(0))/*if board has been solved*/
    {
      solution = i2; /*store solution*/
      printf("%u%s", solution, "\n\n");
    }
    
  }
 
  return 0;
}


unsigned int conv_binary(unsigned int num)
{
    unsigned int result = 0;
    int i = 0, temp = 1,y = 0, x = 0;

    for(i = 0; i< 9; i++)
    {
   
      result = result + pow(10,i) * (num % 2);
      num = num / 2;
    }
    
  return result;
}

int pow(int base, int n)
{
    int i, p;
    p = 1;
    for (i =1; i<=n;i++)
    {
	p *= base;
    }
    return p;
}

	 
unsigned int char_to_int(char array[])
{
  int length = 0, i = 0;
  unsigned num = 0;
 
  length = strlen(array);
 
  for(i = 0; i <length; i++)
    num = num * 10 + (array[i]- '0');

  return num;
}
/* 
  for(i = 0; i < 512; i++)
  {
    i2 = conv_binary(i);
    Lights = char_to_int(InitialState);
    solution = 0;
    pushes = 0;

     printf("%s%u%s%u%s%u%s%u\n", "I: ",i2," 255: ", conv_binary(255)," i^255 = ",i2 ^ conv_binary(255), " should = ", conv_binary(256));

    Does this combination have the button 1 pressed?
    if ((i2 >> 8 == 1)
    {
      printf("%s", "Button1");
      pushes++;
      Lights =(Lights ^ conv_binary(420)); yes, therefore, press 1
    }
    else if((i2 >> 7  == conv_binary(128))
    {
      printf("%s", "Button2");
      pushes++;
      Lights = (Lights ^ conv_binary(466));
    }
    else if((i2 >> 6  == conv_binary(64))
    {
      printf("%s", "Button3");
      pushes++;
      Lights = (Lights ^conv_binary(201));
    }
    else if ((i2 >> 5  == conv_binary(32))
    {
      pushes++;
      Lights = (Lights ^ conv_binary(308));
    }
    else if ((i2 >> 4 == conv_binary(16))
    {
      pushes+    else if ((i2 ^ conv_binary(503)) == conv_binary(8))
    {
      pushes++;
      Lights = (Lights ^ conv_binary(294));  
    }
    else if((i2 ^conv_binary(507)) == conv_binary(4))
    {  
      pushes++;
      Lights = (Lights ^ conv_binary(294));  
    }
    else if ((i2 ^conv_binary(509)) == conv_binary(2))
    {
      pushes++;
      Lights = (Lights ^conv_binary(151));    
    }
    else if((i2 ^conv_binary(510)) == conv_binary(1))
    {
	printf("%s", "Button9");
      pushes++;
      Lights = (Lights ^conv_binary(75));
    }
    if (conv_binary(Lights) == conv_binary(0))if board has been solved
    {
      solution = i2; store solution
      printf("%u%s", solution, "\n\n");
    }
     */
