//Name: Sami Eljabali
//Program 17 Polish 

#include <iostream>
#include <cstring>

using namespace std;

struct node
{
  int   num;
  char  op;
  char  type; //'o'operator, 'n' number
  node* next;
};

node *pop(node *head, int &x, char &oper);
node *popStack(node *head, int &x);
node *stackAdd(node *head, int x);


int main()
{
  node* head;
  node* temp;
  node* ehead;
  char input[50],junk[15];
  char oper;
  int counter, j, arg1, arg2, x;
  

  cout << "Please enter a polish equation: ";
  cin.getline(input, 50);

  head = new node;
  temp = head;

  for (int i = 0; i < strlen(input); i++)
  {
    /*Initailizing*/
    counter = 0;
    for (j=0; j<15; j++)
      junk[j] = '\0';

    if (input[i] == ' ')
    {
      continue;
    }

    else if (isdigit(input[i]))
    {
      while (isdigit(input[i]))
      {
        junk[counter++] = input[i];
        i++;
      }
      temp->num = atoi(junk);
      temp->type = 'n';
    }
    else if (!isdigit(input[i]))
    {
      temp->op = input[i];
      temp->type = 'o';
    }
    
      temp->next = new node;
      temp = temp->next;
    
  }
  temp->type = 'o';
  temp->next = 0;

  ehead = new node;
  ehead->next = 0;

  while(head ->next  != 0)
  {

    char type = head->type;
    
    head = pop(head, x, oper);

   
    if (type == 'n')
    {
      ehead = stackAdd(ehead, x);
    }
    if (type == 'o')
    {
      ehead = popStack(ehead, arg1);
      ehead = popStack(ehead, arg2);
      if (oper == '+')
      {
        ehead = stackAdd(ehead, arg2 + arg1);
      }
      if (oper == '-')
      {
        ehead = stackAdd(ehead, arg2 - arg1);
      }
      if (oper == '/')
      {
        ehead = stackAdd(ehead, arg2 / arg1);
      }
      if (oper == '*')
      {
        ehead = stackAdd(ehead, arg2 * arg1);
      }
    }
  }
  cout  <<  "\nThe answer is: "<< ehead->num << endl;

  cin.get();
  return 0;
}

node *pop(node *head, int &x, char &oper)
{
  if (head->type == 'n')
  {
    x = head->num;
    node *n = head->next;
    delete head;
    head = n;
  }
  else if (head->type == 'o')
  {
    oper = head->op;
    node *n = head->next;
    delete head;
    head = n;
  }
  return head;
}

node *popStack(node *head, int &x)
{
  x = head->num;
  node *temp = head->next;
  head = temp;
  return head;
}

node *stackAdd(node *head, int x)
{
  node *temp = new node;
  temp->num = x;
  temp->next = head;
  head = temp;
  return head;
}