/*
 *Sami Eljabali
 *Assignment #2
 *CS210
 */
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

struct NodeType;
typedef NodeType * NodePtr;

struct RecType
{
	string lname;
	string fname;
	string state;
};

struct NodeType
{
	string lname;
	string fname;
	string state;
	NodePtr nlink;
	NodePtr slink;
};

class TravelerList
{
private:
	NodePtr nameHead;
	NodePtr stateHead;

public:
	TravelerList ();
	void addEntry (RecType r);
	void outputByName (ofstream & f);
	void outputByState (ofstream & f);
};

TravelerList::TravelerList ()
{
	nameHead = NULL;
	stateHead = NULL;
}
void TravelerList::addEntry(RecType r)
{
	
	NodePtr cur,cur2,prev;
	cur=cur2=prev=NULL;
	//Create an entry
	NodePtr newPtr = new NodeType;

	//fill up the entry
	newPtr->lname = r.lname;
	newPtr->fname = r.fname;
	newPtr->state = r.state;

	newPtr->slink = NULL;
	newPtr->nlink = NULL;

	//Link the entry using nlink at its appropriate place
	
	//Name: Empty list
	if (nameHead == NULL)
	{
		nameHead = newPtr;
	}

	//Name: Head insertion
	else if (r.lname < nameHead->lname)
	{
		newPtr->nlink = nameHead;
		nameHead = newPtr;
	}

	//Name: Mid & end insertion: 
	else
	{
		//use the cur to locate the point of insertion
		//let prev walk behind it.
		for (prev=nameHead, cur=nameHead->nlink; cur != NULL;
		     prev=prev->nlink, cur=cur->nlink)
			 {
				 if (newPtr->lname < cur->lname)
					 break;
			 }
		//do the insertion using prev
		newPtr->nlink = prev->nlink;
		prev->nlink = newPtr;
	}

	cur=cur2=prev=NULL;

	//State: Empty List
	if (stateHead == NULL)
	{
		stateHead = newPtr;
		cur2 = newPtr;
	}
	//State: Head insertion
	else if ((newPtr->state < stateHead->state) || ((newPtr->state == stateHead->state) && (newPtr->lname < stateHead->lname)))
	{
		newPtr->slink = stateHead;
		stateHead = newPtr;
		cur2 = newPtr->slink;
	}
	//State: Mid & end insertion
	else //if ((newPtr->state < cur2->state) || ((newPtr->state == cur2->state) && (newPtr->lname < cur2->lname)))
	{
		for (prev=nameHead, cur=nameHead->slink; cur != NULL;
		     prev=prev->slink, cur=cur->slink)
			 {
				 if (newPtr->state < cur->state)
					 break;
			 }
		//do the insertion using prev
		newPtr->slink = prev->slink;
		prev->slink = newPtr;
		cur2 = newPtr;
	}
}

void TravelerList::outputByName (ofstream & f)
{
	f << "Alphabetical Listing By Last Name:\n\n";
	for (NodePtr cur=nameHead; cur != NULL; cur = cur ->nlink)
	{
		f << cur->lname << ", " << cur->fname << " " << cur->state << "\n\n";
	}
	f << "\n\n";
}

void TravelerList::outputByState (ofstream & f)
{	
	f << "Alphabetical Listing By State:\n\n"
	  << "California\n" << "----------\n";
	for (NodePtr cur=stateHead; cur != NULL; cur = cur->slink)
	{
		if (cur->state == "California")
			f << cur->lname << "\n"; 
	}

	f << "\nNew York\n" << "----------\n";
	for (cur=stateHead; cur != NULL; cur = cur->slink)
	{
		if (cur->state == "New York")
			f << cur->lname << "\n"; 
	}
}


void main()
{
	ifstream fin("input.txt");
	ofstream fout ("output.txt");
	RecType rec;

	//createTravelerList object
	TravelerList list;
	string n;

	//User Input
	char buf[102];
	fin.getline(buf,100);
	rec.lname = buf;
	while (!fin.eof())
	{
		fin.getline(buf,100);
		rec.fname = buf;
		fin.getline(buf,100);
		rec.state = buf;
		
		//process the person
		list.addEntry (rec);

		cout << rec.fname << " " << rec.lname << " " << rec.state << endl << endl;
		
		fin.getline(buf,100);
		rec.lname = buf;
	}

	list.outputByName(fout);

	list.outputByState(fout);

	cout << "The list has been sorted and written to the file!";
	cin.get();
}