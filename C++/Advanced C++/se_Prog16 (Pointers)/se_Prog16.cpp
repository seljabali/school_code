 /*Name: Sami Eljabali
  Program 16 Pointers*/

#include <iostream>

using namespace std;

struct entry
{
  int value;
  entry* next;
};

entry *deletenode(int num, entry *head);
entry *insert(entry &n, entry *head);
void printlist(entry*head);

void main()
{
  entry *head;
  entry n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13;
  
  n1.value  = 2;   n2.value  = 6;   n3.value  = 9;   n4.value  = 13;
  n5.value  = 22;  n6.value  = 25;  n7.value  = 30;  n8.value  = 35;
  n9.value  = 40;  n10.value = 50;  n11.value = 17;  n12.value = 75;
  n13.value = 1;

  head     = &n1;  n1.next  = &n2;  n2.next  = &n3;  n3.next  = &n4;
  n4.next  = &n5;  n5.next  = &n6;  n6.next  = &n7;  n7.next  = &n8;
  n8.next  = &n9;  n9.next  = &n10; n10.next = 0;

  printlist(head);
  head = deletenode(2, head);
  head = deletenode(25, head);  
  head = deletenode(50, head);
  
  head = insert(n11, head);  
  head = insert(n12, head);  
  head = insert(n13, head);
  cout << endl <<endl;
  printlist(head);
  cin.get();
}

entry *deletenode(int num, entry *head)
{
  entry *previous = 0;
  entry *temp = head;
  
  if (num == head->value)
  {
    head = head->next;
    return head;
  }
  
  while (temp != NULL)
  {
    if (temp ->value == num)
    {
      previous ->next = temp->next;
      return head;
    }
    else
    {
      previous = temp;
      temp = temp->next;
    }
  }
  previous->next = 0;
  return head;
}

entry *insert(entry &n, entry *head)
{
  entry *previous = 0;
  entry *temp = head;

  if (n.value < head->value)
  {
    head = &n;
    n.next = temp;
    return head;
  }

  previous = head;
  temp = temp->next;

  while (temp != NULL)
  {
    if ((n.value > previous->value) && (n.value < temp->value))
    {
      previous->next = &n;
      n.next = temp;  
      return head;
    }
    else
    {
      previous = temp;
      temp = temp->next;
    } 
  }
  previous->next = &n;
  n.next = 0;
  return head;
}

void printlist(entry*head)
{

 for (entry*p = head; p; p=p->next)
  cout << p->value << endl;
}