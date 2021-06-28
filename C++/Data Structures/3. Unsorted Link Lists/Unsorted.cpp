/*
 *Sami Eljabali
 *CS210
 *Assignment #3
 */
#include <iostream>
#include <string>
using namespace std;

struct NodeType;
	typedef NodeType *NodePtr;
	struct NodeType
	{
		string line;
		NodePtr link;
	};

class LineEdit
{
	private:
		NodePtr head;
		NodePtr cursor;
		int isEmpty();
		NodePtr findPrev();
	public:
		LineEdit();
		void insert (string s);
		void removeLine();
		void move(int n);
		void list();
		void listall();
	};

	LineEdit :: LineEdit ()
	{
		head = NULL;
		cursor = NULL;
	}
	void LineEdit::insert(string s)
	{
		NodePtr prev;
		//Prepare the entry
		NodePtr newPtr = new NodeType;
		newPtr->line = s;
		newPtr->link = NULL;

		//case: Empty insertion
		if (head == NULL)
		{
			head = newPtr;
		}

		//head insertion
		else if (cursor == head)
		{
			newPtr ->link = head;
			head = newPtr;
		}

		else if (cursor != head)
		{
			prev = findPrev ();
			//use prev to do the insertion
			newPtr ->link = prev->link;
			prev->link = newPtr;
		}
	}
	void LineEdit::removeLine ()
	{
		NodePtr temp;
		//case: head removal
		if (head == cursor)
		{
			if (head == NULL)
				cout << "Can't Erase last node." << endl << endl;
			else
			{
				head = cursor->link;
				cursor = head;
				cout << "Deleted!" << endl << endl;
			}
		}
		//case: mid/end removal
		else
		{
			if (cursor == NULL)
				cout << "Can't Erase last node." << endl << endl;
			else
			{
				temp = findPrev();
				cursor = cursor->link;
				temp->link = cursor;
				cout << "Deleted!" << endl << endl;
			}
		}
	}
	void LineEdit::move (int n) 
	{
		//Moving ahead
		if (n >= 0) 
		{
			for (int i=0; i<n; i++)
			{
				if (cursor == NULL)
					break;
				cursor = cursor->link;			
			}
		}
		//Moving Backwards
		else
		{
			n *= -1;
			for (int i=0; i<n; i++)
			{
				if (cursor == head)
					break;
				cursor = findPrev();	
			}
		}
		
		//Display the current line.
		if (cursor == NULL)
			cout <<"<end>" << endl << endl;
		else
			cout << cursor->line << endl << endl;
	}
	void LineEdit::list()
	{
		NodePtr temp;
		temp = cursor;
		while (temp !=NULL)
		{
			cout << temp->line << endl;
			temp = temp->link;
		}
		cout << "<end>" << endl << endl;
	}

	void LineEdit::listall()
	{
		NodePtr temp;
		temp = head;
		while (temp !=NULL)
		{
			cout << temp->line << endl;
			temp = temp->link;
		}
		cout << "<end>" << endl << endl;
	}

	int LineEdit::isEmpty ()
	{
		if (head == NULL)
			return 1;
		else
			return 0;
	}
	//Find Previous
	NodePtr LineEdit::findPrev()
	{
		NodePtr cur;
		for (cur=head; cur != NULL; cur = cur->link)
		{
			if (cur->link == cursor)
				break;
		}
		return cur;
	}
void main ()
{
	char in;
	int num;
	string s;
	LineEdit edit;

	cout << "I: Insert a line followed by '//'" << endl
		 << "D: Delete a line" << endl
		 << "M: Move the cursor is a different line." << endl
		 << "L: List all lines after the cursor." << endl
		 << "A: List all lines in the list." << endl
		 << "X: Exit program." << endl << endl;
	char buf [100];
	while (1)
	{
		cout << ">";
		cout.flush();

		cin >> in;
		cin.ignore();
		switch (in)
		{
		case 'I':
		case 'i':
			cin.getline (buf,100); 
			s = buf;
			while (s != "//")
			{
				edit.insert(s);
				cin.getline (buf,100); 
				s = buf;
			}
			break;
		case 'D':
		case 'd': edit.removeLine();
				  break;
		case 'M':
		case 'm': cin >> num;
				  cout << endl;
			      edit.move(num);
				  break;
		case 'L': 
		case 'l': edit.list();
			      break;
		case 'A': 
		case 'a': cout << endl;
			      edit.listall();
			      break;
		case 'X':
		case 'x': exit(0);
		}
	}
}