/*
 *Sami Eljabali 
 *COMP 210
 *Assignment #4
 */
#include <fstream>
#include <string>
#include <iostream>
using std::cout;

using namespace std;

struct RecType
{
	int type;
	int id;
	int time;
	int data;
};

struct NodeType;
typedef NodeType * NodePtr;

struct NodeType
{
	int type;
	int id;
	int time;
	int data;
	NodePtr link;
};

struct Times;
typedef Times * TimePtr;

struct Times
{
	int totalTime;
};

class SimQue
{
private:
	NodePtr head;
	NodePtr tail;
public:
	SimQue();              
	int isEmpty ();
	void Enque (RecType r);
	RecType Deque ();

	void insert (RecType r);
};

SimQue :: SimQue ()
{
	head = NULL;
	tail = NULL;
}

void SimQue :: Enque (RecType r)
{
	//Prepare a node

	//Create an node
	NodePtr newPtr = new NodeType ;
	//fill up the node
	newPtr->type = r.type;
	newPtr->id = r.id;
	newPtr->time = r.time;
	newPtr->data = r.data;
	newPtr->link = NULL;

	//empty queue
	if (head == NULL && tail== NULL)
	{
		head = newPtr;
		tail = newPtr;
	}

	//end queue
	else
	{
		tail->link = newPtr;
		tail = newPtr;
	}
}

//pre: que is NOT empty
RecType SimQue::Deque()
{
	RecType rec;
	//fill out the rec using head.
	rec.id = head->id;
	rec.type = head->type;
	rec.time = head->time;
	rec.data = head->data;
	//Remove the node
	head = head->link;
	//Test to see if the que became empty after removal
	//In that case, make sure to set the tail to NULL
	if (head == NULL)
		tail = NULL;

	return rec;
}

void SimQue::insert(RecType r)
{
	NodePtr newPtr = new NodeType ;
	//fill up the node
	newPtr->type = r.type;
	newPtr->id = r.id;
	newPtr->time = r.time;
	newPtr->data = r.data;
	newPtr->link = NULL;

	//empty insertion
	if ( isEmpty() )
	{
		newPtr->link = NULL;

		head = newPtr;
		tail = newPtr;
	}

	//head insertion
	else if (newPtr->time < head->time)
	{
		tail = head;

		newPtr->link = head;
		head = newPtr;
	}

	//mid and end insertion
	else
	{
		NodePtr cur = head->link,
			prev = head;


		while (prev)
		{
			if ( newPtr->time < cur->time )
			{
				newPtr->link = cur;
				prev->link = newPtr;
				break;
			}
			cur  = cur->link;
			prev = prev->link;
			if ( cur == NULL )
			{
				newPtr->link = cur;
				prev->link = newPtr;
				break;
			}
		}
	}
}


int SimQue ::isEmpty()
{
	return (head==NULL && tail==NULL)? true: false;
}

void main ()
{
	ifstream fin( "simulation.txt" );
	SimQue timeQ, idleQ, waitQ;
	RecType r, r1, r2;
	int nWorkers, nClients=1;

	fin >> nWorkers;

	fin >> r1.time;
	while (!( fin.eof()))
	{
		fin >> r1.data;
		r1.type = 0;
		r1.id   = nClients;
		timeQ.Enque ( r1 );
		nClients++;
		fin >> r1.time;
	}

	// build idle queue
	for (int i=1; i <= nWorkers; i++)
	{
		r1.type = 1;
		r1.id = i;
		r1.time = r1.data = 0;
		idleQ.Enque (r1);
	}

	int currentTime=0, wIdleTime, wIdle[10] = {0}, cIdleTime, cIdle[70] = {0};

	while (!( timeQ.isEmpty()))
	{
		r=timeQ.Deque();

		currentTime = r.time;

		cout << currentTime;

		//case: customer dequeued and idle workers
		if (!(r.type) && !(idleQ.isEmpty()))
		{
			r1 = idleQ.Deque();
			wIdleTime = currentTime - r1.time;
			wIdle[r1.id] += wIdleTime;

			r1.data = r.id;
			r1.time = currentTime + r.data;
			cout << ": Worker #" << r1.id << " started with customer #" << r.id << ".\n";
			timeQ.insert (r1);
		}

		//case: customer dequeued and no available worker
		else if (!( r.type) && idleQ.isEmpty())
		{
			cout << ": Customer #" << r.id << " put on wait queue.\n";
			waitQ.Enque (r);
		}

		//case: worker dequeued and customer in wait queue
		else if (r.type && !( waitQ.isEmpty()))
		{
			r1 = waitQ.Deque ();
			cIdleTime = currentTime - r1.time;
			cIdle[r1.id] = cIdleTime;

			cout << ": Worker #" << r.id << " finished with customer #" << r.data << ".\n";
			r.data = r1.id;
			r.time = currentTime + r1.data;
			cout << currentTime << ": Worker #" << r.id << " started with Customer #" << r.data << " .\n";
			timeQ.insert (r);
		}

		//case: worker dequeued and no customer in wait queue
		else if (r.type && waitQ.isEmpty())
		{
			cout << ": Worker #" << r.id << " finished with customer #" << r.data << ".\n";
			cout << currentTime << ": Worker #" << r.id << " put on idle queue.\n";
			idleQ.Enque (r);
		}
	}

	//update wait values at the end.
	while (!(idleQ.isEmpty()))
	{
		r2 = idleQ.Deque();
		wIdleTime = currentTime - r2.time;
		wIdle[r2.id] += wIdleTime;
	}

	//Summary
	cout << endl;

	for (i=1; i<nClients; i++)
		cout << "Customer #" << i << " wait time  " << cIdle[i] << endl;

	cout << endl;

	for (i=1; i<=nWorkers; i++)
		cout << "Worker #" << i << " idle time  " << wIdle[i] << endl;
	cin.get();
	cin.get();
}