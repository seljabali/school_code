//7
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

struct NodeType;
typedef NodeType * NodePtr;
struct NodeType
{
	string item;
    NodePtr llink;
    NodePtr rlink;
};

class Tree
{
	private:
		NodePtr root;
	public:
		Tree();
		void store();
		void rstore(NodePtr , ofstream &);
		void restore();
		void rrestore(NodePtr &, ifstream &);
		void Play();
		void rPlay(NodePtr &);
		void notCorrect();
};

Tree::Tree()
{
	root = NULL;
}
void Tree::store()
{
    //open a file object for output
    ofstream outFile ("tree1.txt");
    //assume root is the root of the tree;
    rstore(root, outFile);
    outFile.close ( );
}

void Tree::rstore(NodePtr nodep, ofstream &OutFile)
{
    //item below is a string being written to the file.
    //For a question, the string ends with a question mark (?).
    //For an answer, 
	//it ends with a non question mark, say with a period (.).
	//use pre-order traversal to save the tree.
    if (nodep!=NULL)
    {
		OutFile<<nodep->item <<endl;
        rstore(nodep->llink,OutFile);
        rstore(nodep->rlink,OutFile);
    }        
}

//The methods below can be used for restoring tree 
//from a file prepared by the above methods. by using pre-order traversal.

void Tree::restore( )
{
    //open a file object for input
    ifstream inFile ("tree.txt");
    //assume root is the root of the tree. It may contain NULL at this time.
    rrestore(root, inFile);
    inFile.close ( );
}

void Tree::rrestore(NodePtr &nodep, ifstream &inFile)
{
    //use pre-order traversal for restoring the tree.
    //After reading a line, and creating a node for it, ask if this is a question?
    //If it is a question, make a recursive call to create and fill the next node.
    //If it is not a question (i.e. it is an answer), do not make the recursive call 
    //because there is no node below it.
    //read a line from the file.
	char buf[120];
    inFile.getline(buf,120);
    //create a node.
    //link this node to the node/root above it.
	// The root or left/right link of the node above is passed to this method.         
	nodep = new NodeType; 
	//fill the node.
    nodep->item = buf;
    nodep->llink = NULL;
    nodep->rlink = NULL;
    //if this is a question, make the recursive call 
    //because there is still a node below it.
    if (nodep->item[nodep->item.length( )-1]=='?')
    {
		rrestore(nodep->llink, inFile);
        rrestore(nodep->rlink, inFile);
    }
}

void Tree::Play()
{
	rPlay(root);
}

void Tree::rPlay(NodePtr & nodep)
{
	string answer;
	if (nodep->item[nodep->item.length( )-1]!='?')
	{
		cout<<"My Guess: "<<nodep->item<<endl;
		cout<<"Is it correct? (yes/no) ";
		cin>>answer;
		if(answer == "no")
		{
			NodePtr nodeptr;
			nodeptr = new NodeType;
			cout<<"What's the correct answer? ";
			cin>>answer;
			nodeptr->item = answer;
			nodeptr->rlink = NULL;
			nodeptr ->llink = NULL;
			nodep->rlink = nodeptr;
			cout<<"Provide a question whose \"yes\" answer is your object and \"no\" answer is my guess. ";	
			getline(cin, answer);
			nodeptr->item = answer;
			nodep->llink = nodeptr;
			cout<<"Would you like to play another game?"<<endl;
			cin>>answer;
			if(answer == "yes")
				Play();
			else
				store();
		}
		else
		{
			cout<<"I must say I am smart."<<endl;
			cout<<"Would you like to play another game?"<<endl;
			cin>>answer;
			if(answer == "yes")
				Play();
			else
				store();
		}

	}
	else
	{
		cout<<nodep->item<<endl;
		cin>>answer;
		if(answer == "no")
			rPlay(nodep->llink);
		else
			rPlay(nodep->rlink);	
	}
}

void main()
{
	string ch;
	Tree Game;
	Game.restore();
	Game.store();
	Game.Play();
}
