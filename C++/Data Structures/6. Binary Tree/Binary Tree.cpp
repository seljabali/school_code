/*
 *Sami Eljabali
 *Assingment #6
 */
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>

using namespace std;
 
struct RecType
{
	int id;
	string firstName;
	string lastName;
	double amount;
};
 
struct NodeType;
typedef NodeType * NodePtr;
struct NodeType
{
	int id;
	string firstName;
	string lastName;
	double amount;
	NodePtr llink;
	NodePtr rlink;
};
 
class BinTree
{
private:
  NodePtr root;
  ifstream fin;
  ofstream fout;
  void rinsert (NodePtr & nodep, RecType rec);
  void rupdate (NodePtr nodep, RecType rec );
  void rremove (NodePtr & nodep, RecType rec );
  void rdisplay (NodePtr nodep, int level);
  void rfdisplay (NodePtr nodep, int level, ofstream & fout);
  void rstore (NodePtr nodep);
  void rrestore (NodePtr & nodep, int count);
  int rcountNodes (NodePtr nodep);
 
public:
  BinTree ();
  void insert (RecType rec);
  void update (RecType rec);
  void remove (RecType rec);
  void display ();
  void fdisplay (ofstream & fout);
  void store ();
  void restore ();
  int countNodes ();
};
 

BinTree ::BinTree ()
{
	root = NULL;
}

 /**INSERT**/
void BinTree ::insert (RecType rec)
{
	rinsert (root, rec);
}

void BinTree ::rinsert (NodePtr & nodeptr, RecType rec)
{
	if (nodeptr == NULL) //reached not found
	{                
		//create the node and link it
		nodeptr = new NodeType;
		nodeptr->id = rec.id;
		nodeptr->firstName = rec.firstName;
		nodeptr->lastName = rec.lastName;
		nodeptr->amount = rec.amount;
		nodeptr->llink = NULL;
		nodeptr->rlink= NULL;
	}
	else if  (rec.id < nodeptr->id)

		rinsert(nodeptr->llink, rec);
	else

		rinsert (nodeptr->rlink, rec);
}

/**UPDATE**/
void BinTree ::update (RecType rec )
{
	int found = 0;

	rupdate (root, rec);
}
 
void BinTree ::rupdate (NodePtr nodep, RecType rec)
{
  if (nodep == NULL) 
  {
    //return(false);
  }
  else 
  { 
    if (rec.id == nodep->id) 
	{
		nodep->amount += rec.amount;
	//	return(true);
	}
    else 
	{
      // 3. otherwise recur down the correct subtree
      if (rec.id < nodep->id) 
		  rupdate(nodep->llink, rec);
      else 
		  rupdate(nodep->rlink, rec); 
	}
  }
}
 
/**REMOVE**/
void BinTree ::remove (RecType rec )
{
	rremove (root, rec);
}

void BinTree ::rremove (NodePtr & nodep, RecType rec)
{
	if (rec.id == nodep->id)
	{
		if (nodep->llink == NULL && nodep->rlink == NULL)
			nodep = NULL;
	}
	else if (nodep->llink == NULL)
		nodep = nodep->rlink;
	else if (nodep->rlink == NULL)
		nodep = nodep->llink;
} 

/**DISPLAY**/ //reverse in order traversal with levels
void BinTree::display ()
{
	rdisplay (root, 1);
}
 
void BinTree::rdisplay (NodePtr nodep, int level)    
{
	if (nodep != NULL)
	{
		   rdisplay (nodep->rlink, level + 1);
		   cout <<  setw (7 * level) << nodep->id <<endl;
		   rdisplay (nodep->llink, level + 1);
	}
}

 //Logging the tree in reverse In-order traversal with levels
void BinTree::fdisplay (ofstream & fout)
{
	rfdisplay (root, 1, fout);
}

void BinTree::rfdisplay (NodePtr nodep, int level, ofstream & fout)    
{
	if (nodep != NULL)
	{
		rfdisplay (nodep->rlink, level + 1,fout);
		fout <<  setw (7 * level) << nodep->id <<endl;
		rfdisplay (nodep->llink, level + 1,fout);
	}
}
 
/**STORE**/ //the tree to a file OrderedMaster.txt
void BinTree::store ()
{
	fout.open("OrderedMaster.txt",ios::out );
	//save the node count as the first number in the file
	int count = countNodes();
	fout << count << endl;
	//save the tree
	rstore (root);
	fout.close();
}

void BinTree::rstore (NodePtr nodep)    
{
  if (nodep != NULL)
  {
	rstore (nodep->llink);
	fout << nodep->id << " "
		<< nodep->firstName << " "
		<<  nodep->lastName <<  " "
		<< nodep->amount << endl;
	rstore (nodep->rlink);
  }
}

/**RESTORE**/ //the tree from a file OrderedMaster.txt
void BinTree::restore ()
{
  fin.open("OrderedMaster.txt",ios::in );
  //input node count. This was stored as the first number in file.
  int count;
  fin >> count;
  //restore the tree
  rrestore (root,count);
  fin.close();
}

void BinTree::rrestore (NodePtr & nodep, int count)        
{
  if (count > 0)
  {
	//create a node
	nodep = new NodeType;
	nodep->llink = NULL;
	nodep->rlink = NULL;

          //create and fill the left subtree
    if ((count % 2) == 0)
		rrestore (nodep->llink, ((count-1)/2) + 1);
    else
		rrestore (nodep->llink, count/2);
          //fill in the node
		fin >> nodep->id >> nodep->firstName >> nodep->lastName >> nodep->amount;
          //create and fill the right subtree
    if ((count % 2) == 0)
		rrestore (nodep->rlink, ((count-1)/2) );
    else
		rrestore (nodep->rlink, count/2);
  }
}


/**COUNT**/
int BinTree::rcountNodes (NodePtr nodep )
{
	if (nodep != NULL)
	{
		return (rcountNodes (nodep->llink) + rcountNodes(nodep->rlink) + 1);
	}
	else

	return 0;
}

int BinTree::countNodes ()
{
  return rcountNodes (root);
}

/**MAIN**/
void main ()
{
  BinTree tree;
  ofstream fout ("Log.txt");
  //ofstream fout2 ("NewMaster.txt");
  ifstream finMaster ("Master.txt");
  ifstream finTransaction ("Transaction.txt");
  ifstream finOrderedMaster ("OrderedMaster.txt");
  RecType r; 
  char action;

  finMaster >> r.id;
  while (!finMaster.eof())
  {
	finMaster >> r.firstName;
	finMaster >> r.lastName;
	finMaster >> r.amount; 
	tree.insert(r);
	finMaster >> r.id;
  } 

  //display the tree
  cout << "Original tree" << endl << "*************";
  fout << "Original tree" << endl << "*************";
  tree.display();
  tree.fdisplay(fout);

  //store the tree
  tree.store();

  //restore the tree
  tree.restore();

   //display the restored tree.
  cout << endl << endl << "Restored tree" << endl << "*************";
  fout << endl << endl << "Restored tree" << endl << "*************";
  tree.display();
  tree.fdisplay(fout);

  //Go through transactions
  finTransaction >> action >> r.id >> r.firstName >> r.lastName >> r.amount;
  while (!finTransaction.eof())
  {
	if (action == 'I')
	{
		tree.insert(r);
		fout << "\nInserting ID: " << r.id  << ", Name: " << r.firstName << ", Amount: "<< r.amount << endl << endl;
		tree.fdisplay(fout);
	}
	else if (action == 'U')
	{
		tree.update(r);
		fout << "\nUpdating ID: " << r.id  << ", Name: " << r.firstName << ", Amount: "<< r.amount << endl << endl;
		tree.fdisplay(fout);
	}
	else if (action == 'D')
	{
		tree.remove(r);
		fout << "\nRemoving ID: " << r.id  << ", Name: " << r.firstName << ", Amount: "<< r.amount << endl << endl;
		tree.fdisplay(fout);
	}
	finTransaction >> action >> r.id >> r.firstName >> r.lastName >> r.amount;
  }

  fout << "End of transactions!";

  cin.get();
}