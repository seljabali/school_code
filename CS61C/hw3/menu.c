/* Sami Eljabaly by */

#include <stdio.h>

int Category(char[]);
int Get_num_category(int, char[]);
double Get_price(char[]);
double Get_price_cents(char[]);
void Get_name(char[],char[]);
int Get_name_size(char[]);

int main(int numArgs, char** Args)
{
    char* filename = Args[1];
    char* outputfile = Args[2];
    char buffer[100];

    double closest = atoi(Args[3]);
    double cheap = 0,cheap2 =0,cheap3,expen = 0,expen2=0,expen3=0,sum = 0,sum2 = 0,close = 0,close2 = 0;
    int counter = 0, i = 0, category = 0, temp = 0, j = 0,
	k = 0, size = 0, c1 =0 ,c2 = 0,c3 = 0,e1=0,e2=0,e3=0,cl = 0,cl2 = 0,cl3  =0;

    FILE *out = fopen(outputfile, "w");

    char *Appetizer_names[Get_num_category(1,filename)];
    double Appetizer_prices[Get_num_category(1,filename)];
    double Appetizer_prices_cents[Get_num_category(1,filename)];
    int Appetizer_counter = 0;
    
    char *Entree_names[Get_num_category(2,filename)];
    double Entree_prices[Get_num_category(2,filename)];
    double Entree_prices_cents[Get_num_category(2,filename)];
    int Entree_counter = 0;
    
    char *Dessert_names[Get_num_category(3,filename)];
    double Dessert_prices[Get_num_category(3,filename)];
    double Dessert_prices_cents[Get_num_category(3,filename)];
    int Dessert_counter = 0;

     Appetizer_counter = Entree_counter = Dessert_counter = 0;
    
    FILE *input = fopen(filename, "r");
    
    if (input == NULL)
      printf("Error opening file");
    
    while (fgets(buffer, 100, input))
    {
      if (input != NULL)
      {
        if ((Category(buffer)) == 1)
        {
          Appetizer_prices[Appetizer_counter] = Get_price(buffer);
	  
	size = Get_name_size(buffer);
          Appetizer_names[Appetizer_counter]= (char *) malloc ((size) * sizeof(char));
	Get_name(buffer,Appetizer_names[Appetizer_counter]);

	Appetizer_prices[Appetizer_counter] = Get_price(buffer);
	Appetizer_prices_cents[Appetizer_counter] = Get_price_cents(buffer);
	  
	Appetizer_counter++;
          size = 0;
        }
        else if ((Category(buffer)) == 2)
        {
	  
            Entree_prices[Entree_counter] = Get_price(buffer);

	  size = Get_name_size(buffer);
            Entree_names[Entree_counter]= (char *) malloc ((size) * sizeof(char));
	  Get_name(buffer,Entree_names[Entree_counter]);

	  Entree_prices[Entree_counter] = Get_price(buffer);
	  Entree_prices_cents[Entree_counter] = Get_price_cents(buffer);
	  
            Entree_counter++;
	  size = 0;
        }
        else if ((Category(buffer)) == 3)
        {
            Dessert_prices[Dessert_counter]= Get_price(buffer);

	  size = Get_name_size(buffer); 
            Dessert_names[Dessert_counter] = (char *) malloc ((size) * sizeof(char));
	  Get_name(buffer,Dessert_names[Dessert_counter]);  

	  Dessert_prices[Dessert_counter] = Get_price(buffer);
	  Dessert_prices_cents[Dessert_counter] = Get_price_cents(buffer);

	  size = 0;
            Dessert_counter++;
        }
      }
    }



    for(i=0;i<Appetizer_counter; i++)
    {
	if (Appetizer_prices[i] > (expen/1))
	{
	    expen = Appetizer_prices[i];
	    e1 = i;
	}
	else if(Appetizer_prices[i] == (expen/1))
	{
	    if(Appetizer_prices_cents[i] > (expen/1))
	    {
		expen = Appetizer_prices[i];
		e1 = i;
	    }
	}
	if (Appetizer_prices[i] < (cheap/1))
	{

	    cheap = Appetizer_prices[i];
	    c1 = i;
	}
	else if(Appetizer_prices[i] == (cheap/1))
	{
	    if(Appetizer_prices_cents[i] < (cheap/1))
	    {
		cheap = Appetizer_prices[i];
		c1 = i;
	    }
	}
    }
    for(j=0;j<Entree_counter;j++)
    {
	    if (Entree_prices[j] > (expen2/1))
	    {
		expen2 = Entree_prices[j];
		e2 = j;
	    }
	    else if(Entree_prices[j] == (expen2/1))
	    {
		    if(Entree_prices_cents[j] > (expen2/1))
		    {
			    expen2 = Entree_prices[j];
			    e2 = j;
		    }
	    }	
	    if (Entree_prices[j] < (cheap2/1))
	    {

		cheap2 = Entree_prices[j];
		c2 = j;
	    }
	    else if(Entree_prices[j] == (cheap2/1))
	    {
		if(Entree_prices_cents[j] < (cheap2/1))
		{
		    cheap2 = Entree_prices[j];
		    c2 = j;
		}
	    }
    }
    for(k=0;k<Dessert_counter; k++)
    {
      if (Dessert_prices[k] > (expen3/1))
      {
	expen3 = Dessert_prices[k];
	e3 = k;
      }
      else if(Dessert_prices[k] == (expen3/1))
      {
         if(Dessert_prices_cents[k] > (expen3/1))
		    {
			    expen3 = Dessert_prices[k];
			    e3 = k;
		    }
		}	
		if (Dessert_prices[k] < (cheap3/1))
		{

		    cheap3 = Dessert_prices[k];
		    c3 = k;
		}
		else if(Dessert_prices[k] == (cheap3/1))
		{
		    if(Dessert_prices_cents[k] < (cheap3/1))
		    {
			cheap3 = Dessert_prices[k];
			c3 = k;
		    }
		}
	    }

    for(i=0;i<Appetizer_counter; i++)
    {
       for(j=0;j<Entree_counter;j++)
       {
	for(k=0;k<Dessert_counter; k++)
          {
	      if (i == 0 && j==0 && k==0)
	      {
		  close = Appetizer_prices[i] + Entree_prices[j]  + Dessert_prices[k];
		  close2 = Appetizer_prices_cents[i] + Entree_prices_cents[j]  + Dessert_prices_cents[k];
	      }
	      else
	      {
		  sum =  Appetizer_prices[i] + Entree_prices[j]  + Dessert_prices[k];
		  sum2 =  Appetizer_prices_cents[i] + Entree_prices_cents[j]  + Dessert_prices_cents[k];
	      }
	      
	      if (abs(sum-closest/1) < abs(close-closest/1))
	      {
		  close = sum;
		  close2 = sum2;
		  cl=i;
		  cl2=j;
		  cl3=k;
	      }
	      else if (abs(sum-closest/1) == abs(close-closest/1))
	      {
		  if(abs((sum2)-closest/1) < abs(close2-closest/1))
		  {
		      close = sum;
		      close2 = sum2;
		      cl=i;
		      cl2=j;
		      cl3=k;	  
		  }
	      }
	  }
       }
    }
    /*OUTPUT*/
        i=0;
     fprintf(out, "Cheapest\nAppetizer:\t");
        while ( *(Appetizer_names[c1]+ i) != '\0')
        {
          fprintf (out,  "%c",(*(Appetizer_names[c1] + i)));
            i++;
        }
      fprintf (out, "\nEntre:\t");
        i=0;
        while ( *(Entree_names[c2]+ i) != '\0')
        {
            fprintf (out,"%c",*(Entree_names[c2] + i));
            i++;
        }
	
        fprintf (out,"\nDessert:\t");
        i=0;
        while ( *(Dessert_names[c3]+ i) != '\0')
        {
            fprintf (out,"%c",*(Dessert_names[c3] + i));
            i++;
	    }

	
        fprintf (out,"\nMost Expensive\nAppetizer:\t");
	i=0;
        while ( *(Appetizer_names[e1]+ i) != '\0')
        {
           fprintf (out,"%c",(*(Appetizer_names[e1] + i)));
            i++;
        }
       fprintf (out, "\nEntre:\t");
        i=0;
        while ( *(Entree_names[e2]+ i) != '\0')
        {
            fprintf (out,"%c",*(Entree_names[e2] + i));
            i++;
        }
	
       fprintf (out, "\nDessert:\t");
        i=0;
        while ( *(Dessert_names[e3]+ i) != '\0')
        {
            fprintf (out,"%c",*(Dessert_names[e3] + i));
            i++;
         }
	fprintf(out,"\n");
	if(numArgs==4)
	   fprintf(out,"Closest\nAppetizer:\t%s\nEntre:\t%s\nDessert:\t%s\n",Appetizer_names[cl],Entree_names[cl2],Dessert_names[cl3]); 

    fclose(out);
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

int Get_num_category(int num,  char filename[])
{
  FILE *input = fopen(filename, "r");
  int i = 0,counter = 0, num_category = 0;
  char buffer[100];

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

  input =0;
  fclose(input);
  return num_category;
}
double Get_price(char buffer[])
{
  int i = 0;
  double num = 0, nth = 1.0;

  while(buffer[i] != ',')      
    i++;
 
  i = i + 3;
  while((buffer[i] != '.') && (buffer[i] != ','))
  {
    num = (num * 10) + (buffer[i] - '0');
    i++;
  }

  return num;
}
double Get_price_cents(char buffer[])
{
    int i=0, counter = 0, j = 0;
    double dec_num = 0, nth = 1.0;

    while(buffer[i] != ',')      
      i++;
  
    i = i + 3;
    
    while(buffer[i] != '.')
	i++;
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
    return dec_num;
}
void Get_name(char buffer[], char edited[])
{
    int i =0, counter = 0;

    while(buffer[i] != ',')
    {
        if((buffer[i] >=65 && buffer[i] <= 90) || (buffer[i] >=97 && buffer[i] <=122) || buffer[i] == 32)
        {
	  edited[counter] = buffer[i];
            counter++;
        }
        i++;
    }
    edited[counter] = '\0';
}

int Get_name_size(char buffer[])
{
    int good = 0, i =0;

    while(buffer[i] != ',')
    {
        if((buffer[i] >=65 && buffer[i] <= 90) || (buffer[i] >=97 && buffer[i] <=122) || buffer[i] == 32)
            good++;
        i++;
    }
    good++;
    return good;
}
