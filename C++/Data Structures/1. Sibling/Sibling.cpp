/*
 *Sami Eljabali
 *CS210
 *Assignment #1
 */

#include <iostream>
#include <string>

using namespace std;

class Sibling
{
	private:
		string name;
		int age;
		int weight;

	public:
		Sibling ();
		Sibling (string n, int a, int w);
		string getName ();
		int getAge ();
		int getWeight ();
};

	Sibling::Sibling ()
	{
		name = "dumbo";
		age = 0;
		weight = 0;
	}
	Sibling::Sibling (string n, int a, int w)
	{
		name = n;
		age = a;
		weight = w;

	}
	string Sibling::getName ()
	{
		return name;
	}

	int Sibling::getAge ()
	{
		return age;
	}

	int Sibling::getWeight ()
	{
		return weight;
	}

int main ()
{

	string name, name2, name3;
	int age, age2, age3;
	int weight;
	int i = 0;
	Sibling *sib[3];

	for (i = 0; i < 3; i++)
	{
		cout << "Enter sibling #" << i+1 << "'s name: ";;
		cin  >> name;
		cout << "Enter sibling #" << i+1 << "'s age: ";
		cin  >> age;
		cout << "Enter sibling #" << i+1 << "'s weight: ";
		cin  >> weight;
		cout << endl;

		sib[i] = new Sibling(name, age, weight);
	}
	age  = sib[0]->getAge(); 
	age2 = sib[1]->getAge();
	age3 = sib[2]->getAge();

	name  = sib[0]->getName(); 
	name2 = sib[1]->getName();
	name3 = sib[2]->getName();

	if (age < age2 && age < age3)
	
		cout << "The youngest sibling is: " << name << endl;

	else if (age2 < age && age2 < age3)
		
		cout << "The youngest sibling is: " << name2 << endl;
	
	else if (age3 < age && age3 < age2)

		cout << "The youngest sibling is: " << name3 << endl;
	

	age  = sib[0]->getWeight(); 
	age2 = sib[1]->getWeight();
	age3 = sib[2]->getWeight();

	if (age < age2 && age < age3)
	
		cout << "The lightest sibling is: " << name << endl;

	else if (age2 < age && age2 < age3)
		
		cout << "The lightest sibling is: " << name2 << endl;
	
	else if (age3 < age && age3 < age2)

		cout << "The lightest sibling is: " << name3;

	cin.get();
	cin.get();
	return 0;
}
