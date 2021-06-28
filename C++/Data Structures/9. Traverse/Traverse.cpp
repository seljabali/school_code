/*
 *Sami Eljabali
 *Assignment #: 9 
 */
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct NodeType;
typedef NodeType * NodePtr;
struct NodeStackType;
typedef NodeStackType * NodeStackPtr;


class IntQue
{
private:
	NodePtr head, tail;
public:
	IntQue ();
	void enque ( int item );
	int deque ();
	int isEmpty ();
};

class IntStack
{
private:
	NodePtr head;
public:
	Stack ();
	void push ( int n );
	int pop ();
	int isEmpty();	
};

struct NodeType
{
	int item;
	NodePtr link;
};
IntStack::Stack()
{
	head = NULL;
}
IntQue::IntQue ()
{
	head = NULL;
	tail = NULL;
}


void IntQue::enque (int item) 
{
	//Prepare a node
	
	//Create an node
	NodePtr node = new NodeType;
	//fill up the node
	node->item = item;
	node->link = NULL;
	
	//link the node
	
	//case empty queue
	if (head == NULL && tail== NULL) 
	{
		head = node;
	}
	
	//case end queue
	else
	{
		tail->link = node;
	}
	tail = node;
}

int IntQue::deque()
{
	NodePtr cur;
	cur = head;
	//Remove the node
	head = head->link;
	//Test to see if the que became empty after removal
	//In that case, make sure to set the tail to NULL
	if (head == NULL)
		tail = NULL;
	
	return (cur->item);
}

int IntQue::isEmpty()
{
	return (head==NULL && tail==NULL)? true: false;
}

void IntStack::push (int item) 
{
	//Prepare a node	
	//Create an node
	NodePtr node = new NodeType ;
	//fill up the node
	node->item = item;
	node->link = head;
	head=node;
	
	link the node
	case empty queue
	if (head == NULL ) 
	{
		head = node;
		node->link = NULL;
	}
	else
	{
		while (node->link != head)
			node = node->link;
		node->item = item;
	}
}

int IntStack::pop()
{
	int item=head->item;
	//Remove the node
	if (head->link ==NULL)
		head = NULL;
	else
	head = head->link;
	
	return (item);
}

int IntStack::isEmpty()
{
	return (head==NULL)? true: false;
}


class Graph
{
private:
	string vertices[20];
	int edges[20][20];
	int vSize;
public:
	Graph();
	void addVertex (string vertex);
	void addEdge (int fromV, int toV);
	void getAdjacent (int vertex, IntQue & adjQ);
	void getAdjacent (int vertex, IntStack & adjQ);
	void breadthFirst (int startV );
	void depthFirst (int startV );
};

Graph::Graph( )
{
	vSize = 0;
	for (int i=0; i<20; i++)
	{
		for (int j=0; j<20; j++)
			edges [i][j] = 0;
	}
}

void Graph::addVertex (string vertex)
{
	//add the next vertex at the next index in the array
	vertices [vSize] = vertex;
	
	vSize ++;
}

void Graph::addEdge (int fromV, int toV)
{
	//set to 1 the appropriate element in the matrix.
	//Since it is non-directed graph. 
	//Set to 1 the other corresponding element to 1
	edges [fromV][toV] = 1;
	edges [toV][fromV] = 1;
}


void Graph::breadthFirst (int startV)
{
	IntQue mainQ, adjacentQ;
	int vertexMarked[20]={0};
	int vertex;
	//Enque the start vertex in the mainQ.  
	mainQ.enque(startV);
	while (!( mainQ.isEmpty()) )
	{
		//>>>>Deque a vertex from the mainQ.
		vertex = mainQ.deque();
		//Process the dequeued vertex as follows.
		if(vertexMarked[vertex]==0)
		{
			
			//>>>>Display the vertex.
			cout << vertices[vertex] << ' ';			
			//>>>>Mark the vertex as traversed.
			vertexMarked[vertex] = 1;			
			//Get a list of all its adjacent vertices by calling a method (say getAdjacent ) as below.
			//(Note: getAdjacent returns adjacent vertices in a queue, adjacentQ, passed to it as below).
			//(Note: getAdjacent returns vertices in order with the lowest numbered vertex first).
			getAdjacent (vertex, adjacentQ);
			
			//Now enqueue all adjacent vertices to the mainQ.
			// Do this by dequeing them from adjacentQ and enqueing them into mainQ as below.
			while ( !( adjacentQ.isEmpty() ) )
			{
				//>>>Deque a vertex from adjacentQ.
				vertex = adjacentQ.deque();
				if(!(vertexMarked[vertex]))
				{
					//>>>Enque the adjacent vertex in the mainQ.
					mainQ.enque(vertex);
				}
			}
		}
	}
	cout<< endl;
}

void Graph::getAdjacent (int vertex, IntQue & adjQ)
{
	//Any vertex to which I have an edge present is my adjacent vertex.
	for (int i=0; i< vSize; i++)
	{
		if (edges[vertex][i] == 1)
			adjQ.enque (i);
	}
}

void Graph::depthFirst (int StartV )
{
	int vertex;
	int vertexMarked[20]={0};
	IntStack mainStack, adjacentStack;
	//Push the start vertex in the mainStack.
	mainStack.push(StartV);
	while ( !( mainStack.isEmpty() ) )
	{
		//>>>>>Pop a vertex from the mainStack.
		vertex = mainStack.pop();
		
		//Process the popped vertex as follows.
		if( vertexMarked[vertex]==0 )
		{
			
			//>>>>>Display the vertex.
			cout << vertices[vertex] <<' ';
			
			//>>>Mark the vertex as traversed.
			vertexMarked[vertex]=1;
			
			//Get a list of all its adjacent vertices by calling a method (say getAdjacent ) as below.
			//(Note: getAdjacent returns adjacent vertices in a stack, adjacentStack, passed to it as below).
			//(Note: getAdjacent returns vertices in order with the highest numbered vertex on top).
			
			getAdjacent (vertex, adjacentStack);
			
			//Process adjacent vertices by popping them from adjacentStack and pushing them in the mainStack.
			while ( !( adjacentStack.isEmpty() ) )
			{
				//>>>>Pop a vertex from adjacentStack.
				vertex=adjacentStack.pop();
				if( !(vertexMarked[vertex]) )
				{
					//>>>>Push the adjacent vertex in the mainStack.
					mainStack.push(vertex);
				}
			}
		}
	}
	
}
void Graph::getAdjacent (int vertex, IntStack & adjQ)
{
	//Any vertex to which I have an edge present is my adjacent vertex.
	for (int i=0; i< vSize; i++)
	{
		if (edges[vertex][i] == 1)
			adjQ.push (i);
	}
}


void main ()
{
	//Create a Graph object
	Graph graph;
	string vertexName;
	char file[] = "datafile.txt", name[20]="0";
	ifstream inFile (file);
	int vertexNumber, startVertex, endVertex, choice;
	
	
	//Repeatedly do the following until a negative value for a vertex is read.
	do
	{
		///////input vertex number from the file.
		inFile >> vertexNumber;
		
		///////input vertex name from the file.
		inFile.ignore();
		inFile.getline(name, 20);
		vertexName = name;
		if (vertexNumber>=0)
			//add the vertex to the graph
			graph.addVertex (vertexName);
		
	}while (vertexNumber>=0);
	
	//Repeatedly do the following until a negative value for a vertex is read.
	do
	{
		///////input startVertex number of the edge from the file.
		inFile >> startVertex;
		///////input endVertex number of the edge from the file.
		inFile >> endVertex;
		if (startVertex>=0)
			//register the edge in edges matrix.
			graph.addEdge (startVertex, endVertex);
	}while(startVertex>=0);
	//Display menu to the user with options for: breadthFirst or depthFirst
	cout << "Enter a choice(0-Breath First 1-Depth First): ";
	
	//input user's choice
	cin >> choice;
	
	//input the start vertex.
	cout << "Please enter starting vertex: ";
	cin >> vertexNumber;
	
	//call the appropriate method and pass it the startVertex.
	if (!(choice))
		graph.breadthFirst (vertexNumber);
	else
		graph.depthFirst (vertexNumber);
	
}
