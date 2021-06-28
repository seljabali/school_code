#include <stdio.h>

int Category(char[]);
int Get_num_category(char[], int, char[]);
double long Get_price(char[]);
char* Get_name(char[]);

int main()
{
	char filename[] = "c:/sample.txt", buffer[100];
	int counter = 0, i = 0, category = 0, temp = 0, j = 0, k = 0;
	FILE *input = fopen(filename, "r");
	FILE *output = fopen(filename, "w");

	char *Appetizer_names[50];
	double long Appetizer_prices[50];
	int Appetizer_counter = 0;

	char *Entree_names[50];
	double long Entree_prices[50];
	int Entree_counter = 0;
	
	char *Dessert_names[50];
	double long Dessert_prices[50];
	int Dessert_counter = 0;

	Appetizer_counter = Entree_counter = Dessert_counter = 0;

	if (input == NULL)
	  printf("Error opening file");

	while (fgets(buffer, 100, input))
	{
	  if (input != NULL)
	  {
	    if ((Category(buffer)) == 1)
	    {
	      Appetizer_prices[Appetizer_counter] = Get_price(buffer);
		  Appetizer_names[Appetizer_counter]= Get_name(buffer);
	      Appetizer_counter++; 
	    }
	    else if ((Category(buffer)) == 2)
		{
			Entree_prices[Entree_counter] = Get_price(buffer);
			Entree_names[Entree_counter]= Get_name(buffer);
			Entree_counter++;
		}
	    else if ((Category(buffer)) == 3)
		{
			Dessert_prices[Dessert_counter]= Get_price(buffer);
			Dessert_names[Dessert_counter] = Get_name(buffer);
			Dessert_counter++;
		}
	  }
	}   
	
	for (j = 0; j<Entree_counter; j++)
	{	
		i=0;
		while ( *(Entree_names[j]+ i) != '\0')
		{
			printf("%c",*(Entree_names[j] + i));
			i++;
		}
		printf(": %f\n", Entree_prices[j]);
	}
	return 0;
}

/*Functions*/
int Category(char buffer[])
{
  int i = 0, counter = 0;
  
  while(buffer[i] != '\0')
  {
    if (counter == 2)
    {
      if (buffer[i] == '1')
		return 1;
      else if (buffer[i] == '2')
		return 2;
      else if (buffer[i] == '3')
		return 3;
    }
    if (buffer[i] == ',')
      counter++;
    i++;
  }
  printf("\nCould not read category\n");
  return 0;
}

int Get_num_category(char buffer[], int num,  char filename[])
{
  FILE *input = fopen(filename, "r");
  int i = 0,counter = 0, num_category = 0;

  if(input == NULL)
  {
    printf("Error opening file");
    return 0;
  }

  while (fgets(buffer, 100, input))
  {
    while(buffer[i] != '\0')
    {
	if (counter == 2)
	  {
	    counter = 0;
	    if ((buffer[i+1] - '0') == num)
	      num_category++;
	  }
	if (buffer[i] == ',')
	  counter++;
	i++;
    }
    i = 0;
  }

  fclose(input);
  return num_category;
}
double long Get_price(char buffer[])
{
  int i = 0, counter= 0, j = 0;
  double long num = 0, dec_num = 0, nth = 1.0;

  while(buffer[i] != ',')	  
    i++;
  
  i = i + 3;
  while((buffer[i] != '.') && (buffer[i] != ','))
  {
	num = (num * 10) + (buffer[i] - '0');
	i++;
  }
  if (buffer[i] == ',')
	  return num;

  i++;
  while (buffer[i] != ',')
  {
	counter++;
	nth = 1.0;
	for(j = 0; j < counter; j++)
	{ 
		nth = nth/10;
	}
	dec_num = dec_num + ((buffer[i]-'0') * nth);
	i++;
  }

  return (num + dec_num);
}
char* Get_name(char buffer[])
{
	char old[50];
	int good = 0, i =0, counter = 0;
	char * edited; 

	while(buffer[i] != ',')
	{
		old[i] = buffer[i];
		if((buffer[i] >=65 && buffer[i] <= 90) || (buffer[i] >=97 && buffer[i] <=122) || buffer[i] == 32)
			good++;
		i++;
	}
	i=0;
	edited = (char *) malloc ((good+1) * sizeof(char));
	edited[good] = '\0';

	while(old[i] != '\0')
	{
		if((old[i] >=65 && old[i] <= 90) || (old[i] >=97 && old[i] <=122) || old[i] == 32)
		{
			edited[counter] = old[i];
			counter++;
		}
		i++;
	}
	return edited;
}