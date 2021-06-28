//Name: Sami Eljabali
//Program 24 Dbly Linked list

#include <iostream>
#include <cstring>
using namespace std;


struct node
{
  node   *prev;
  double num;
  char   op;
  char   type;
  node   *next;
};

void printlist(const node *head);
void printlistback(const node *tail);
void bigmama(node *head);

int main()
{ 
  node* head = 0, *temp = 0, *prev = 0, *tail = 0;
  char input[50],junk[15];
  int counter, j;
  
  /*****************
   ******INPUT******
   *****************/
  cout << "Please enter an equation: ";
  cin.getline(input, 50);

  head = new node;
  temp = head;
  temp->prev = 0;
  temp->op = '(';
  temp->type = 'l';
  prev = temp;
  temp = new node;
  prev->next = temp;
  prev->prev = 0;
  temp->prev = prev;

  for (int i = 0; i < strlen(input); i++)
  {
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
      temp->num = (double)atoi(junk);
      temp->type = 'n';
      temp->next = new node;
      prev = temp;
      temp = temp->next;
      temp->next = 0;
      temp->prev = prev;
      i--;
    }
    else if (input[i] == '+' || input[i] == '-' || input[i] == '*' || input[i] == '/')
    {
      temp->op = input[i];
      temp->type = 'o';
      temp->next = new node;
      prev = temp;
      temp = temp->next;
      temp->next = 0;
      temp->prev = prev;
    }
    else if (input[i] == '(')
    {
      temp->op = input[i];
      temp->type = 'l';
      temp->next = new node;
      prev = temp;
      temp = temp->next;
      temp->next = 0;
      temp->prev = prev;
    }
    else if (input[i] == ')')
    {
      temp->op = input[i];
      temp->type = 'r';
      temp->next = new node;
      prev = temp;
      temp = temp->next;
      temp->next = 0;
      temp->prev = prev;
    }
  }
  temp->op = ')';
  temp->type = 'r';
  temp->next = 0;
  temp->prev = prev;
  tail = temp;

  /*****************
   *****PROCESS*****
   *****************/
  while (head->type != 'n')
  {
    
    while (temp->type != 'r')
      temp = temp->next;
    while (temp->type != 'l')
      temp = temp->prev;
    bigmama(temp);
    temp = head->next;
    if (temp->prev->prev == 0 && temp->next->next == 0)
    {
      head->next->prev = 0;
      temp = head;
      head = head->next;
      delete temp;
      tail->prev->next = 0;
      temp = tail;
      tail = tail->prev;
      delete temp;
      break;
    }
  }

  /*****************
   *****OUTPUT******
   *****************/
  cout << "\nThe answer is: " << head->num;
  cin.get();
  return 0;
}


void printlist(const node *head)
{
  for (const node *p = head; p; p = p->next)
  {
    if(p->type == 'o')
      cout << "Operator: " << p->op << endl;
    else if(p->type == 'n')
      cout << "Digit: " << p->num << endl;
    else if(p->type == 'r')
      cout << "R Paranthesis: " << p->op << endl;
    else if(p->type == 'l')
      cout << "Left Paranthesis: " << p->op << endl;
  }
}
void printlistback(const node *tail)
{
  for (const node *p = tail; p; p = p->prev)
  {
    if(p->type == 'o')
      cout << "Operator: " << p->op << endl;
    else if(p->type == 'n')
      cout << "Digit: " << p->num << endl;
    else if(p->type == 'r')
      cout << "R Paranthesis: " << p->op << endl;
    else if(p->type == 'l')
      cout << "Left Paranthesis: " << p->op << endl;
  }
}

void bigmama(node *head)
{
  node *temp = head;
  node *fake;
  double num1, num2, ans;
  num1 = num2 = ans = 0;
  while (temp->type != 'r')
  {
    if (temp->op == '*' && temp->type == 'o')
    {
      num2 = temp->next->num;
      num1 = temp->prev->num;
      ans = num1 * num2;
      fake = temp;
      temp = temp->prev;
      temp->next = fake->next->next;
      temp->next->prev = temp;
      delete fake->next;
      delete fake;
      temp->num = ans;
    }
    else
      temp = temp->next;
  }
  
  temp = head;
  while (temp->type != 'r')
  {
    if (temp->op == '/' && temp->type == 'o')
    {
      num2 = temp->next->num;
      num1 = temp->prev->num;
      ans = num1 / num2;
      fake = temp;
      temp = temp->prev;
      temp->next = fake->next->next;
      temp->next->prev = temp;
      delete fake->next;
      delete fake;
      temp->num = ans;
    }
    else
      temp = temp->next;
  }
  
  temp = head;
  while (temp->type != 'r')
  {
    if (temp->op == '+' && temp->type == 'o')
    {
      num2 = temp->next->num;
      num1 = temp->prev->num;
      ans = num1 + num2;
      fake = temp;
      temp = temp->prev;
      temp->next = fake->next->next;
      temp->next->prev = temp;
      delete fake->next;
      delete fake;
      temp->num = ans;
    }
    else
      temp = temp->next;
  }
  
  temp = head;
  while (temp->type != 'r')
  {
    if (temp->op == '-' && temp->type == 'o')
    {
      num2 = temp->next->num;
      num1 = temp->prev->num;
      ans = num1 - num2;
      fake = temp;
      temp = temp->prev;
      temp->next = fake->next->next;
      temp->next->prev = temp;
      delete fake->next;
      delete fake;
      temp->num = ans;
    }
    else
      temp = temp->next;
  }
  
  if (head->prev != 0 && temp->next != 0)
  {
    head->next->prev = head->prev;
    head->prev->next = head->next;
    delete head;
    temp->next->prev = temp->prev;
    temp->prev->next = temp->next;
    delete temp;
  }
}