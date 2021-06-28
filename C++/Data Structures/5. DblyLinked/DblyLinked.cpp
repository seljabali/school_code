/*
 *Sami Eljabali
 *Assignment 5
 */
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct NodeType;
typedef NodeType * NodePtr;
struct RecType
{
	long id;
	string fname;
	string lname;
	double amount;
};

struct NodeType
{
	long id;
	string fname;
	string lname;
	double amount;
	NodePtr flink;
	NodePtr blink;

};
class AccountList
{
private:
	NodePtr head;
	NodePtr cursor;
public:
	AccountList();
	void addAccountSorted (RecType rec);
	void updateAccount(RecType rec);
	void display(ofstream &lfstream);
};

AccountList::AccountList()
{
	head = new NodeType;
	head->id = -1;
	head->fname = "";
	head->lname = "";
	head->amount= -999.999;
	head->flink=head;
	head->blink=head;
	cursor = head;

}
void AccountList::addAccountSorted(RecType rec)
{
	//Creat the new node and fill it in.
	NodePtr newPtr = new NodeType;
	newPtr->id = rec.id;
	newPtr->fname = rec.fname;
	newPtr->lname = rec.lname;
	newPtr->amount = rec.amount;
	newPtr->flink = NULL;
	newPtr->blink = NULL;
	//find the Node of point of insertion
	NodePtr cur, prev;
	for (cur=head->flink; cur!=head; cur=cur->flink)
	{
		if (rec.id < cur->id)
			break;
	}
	//set prev
	prev = cur->blink;
	
	//update the two forward links
	newPtr->flink=prev->flink;
	prev->flink = newPtr;
	//update the two backward links
	newPtr->blink = cur->blink;
	cur->blink = newPtr;

}
void AccountList::updateAccount(RecType rec)
{
	//move the cursor forward if at dummy node
	if (cursor == head)
		cursor = cursor->flink;
	//cursor is at the target node. do not move it
	if (cursor->id == rec.id)
	{
		//update the account
		cursor->amount += rec.amount;

		//if the account became zero or negative
		if (cursor->amount <= 0)
		{
			cursor->blink->flink = cursor->flink;
			cursor->flink->blink = cursor->blink;
			//delete the node and move the cursor forward
			cursor = cursor->flink;
		}
	}
	else if (cursor->id < rec.id)
	{
		while (cursor != head)
		{
			if (cursor->id >= rec.id)
				break;
			cursor = cursor->flink;
		}
		if (cursor->id == rec.id)
		{
			cursor->amount += rec.amount;
			if (cursor->amount <= 0)
			{
				cursor->blink->flink = cursor->flink;
				cursor->flink->blink = cursor->blink;
				//delete the node and move the cursor forward
				cursor = cursor->flink;
			}
		}
		else
		{
			addAccountSorted (rec);
		}
	}
	else
	{
		while (cursor != head)
		{
			if (cursor->id <= rec.id)
				break;
			cursor = cursor->blink;
		}

		if (cursor->id == rec.id)
		{
			cursor->amount += rec.amount;
			//if the account became zero or negative
			if (cursor->amount <= 0)
			{
				cursor->blink->flink = cursor->flink;
				cursor->flink->blink = cursor->blink;
				//delete the node and move the cursor forward
				cursor = cursor->flink;
			}
		}
		else
		{
			//first move the cursor forward by one
			cursor = cursor->flink;
			//This will make it point to the point of insertion node.
			//Then insert the node prior to where cursor is.
			addAccountSorted (rec);
		}
	}
}

//This method receives an ofstream opened for the log file 
//as a reference parameter and uses it to write the contents
//of the doubly linked list to the log file.
//This method can be used while performing updates.
void AccountList::display(ofstream & lfout)
{
	for(NodePtr cur = head->flink; cur!=head; cur=cur->flink)
		lfout << cur->id << " " << cur->fname << " " << " " << cur->lname << " " 
		      << cur->amount << endl;

}
void main ()
{
	ifstream fin("master.txt");
	ifstream fin2("tran.txt");
	ofstream lfout ("log.txt");
	AccountList al;
	RecType r1;
	int counter=1;

	//Reading master file
	while (!(fin.eof()))
	{
		fin >> r1.id >> r1.fname >> r1.lname >> r1.amount;
		al.addAccountSorted(r1);
	}
	lfout << "Master File" << endl << endl;
	al.display(lfout);

	//Readin Transaction File
	while (!(fin2.eof()))
	{
		//input
		fin2 >> r1.id >> r1.fname >> r1.lname >> r1.amount;
		
		//process
		al.updateAccount(r1);

		//output
		lfout << endl << "Update#" << counter << endl << endl
			  << r1.id << " " << r1.fname << " " << r1.lname << " " << r1.amount
			  << endl << endl;
		al.display(lfout);
		lfout << endl << endl;

		counter++;
	}
	lfout << "End Of Transactions!";

	cin.get();
}