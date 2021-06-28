#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <fstream>
#include <string>

using namespace std;
struct NodeStackType;
typedef NodeStackType * NodeStackPtr;

struct NodeStackType
{
	int item;
	NodeStackPtr link;
};

//The code below assumes IntQue and IntStack as user provided classes.
//Please write those classes first. 

class IntStack
{
private:
	NodeStackPtr head;
public:
	Stack ();
	void push ( int n );
	int pop ();
	int isEmpty();	
};


IntStack::Stack()
{
	head = NULL;
}

void IntStack::push (int item) 
{
	NodeStackPtr stackNode = new NodeStackType;
//	stackNode->item=item;
//	stackNode->link=head;

	head=stackNode;


}

int IntStack::pop()
{
	int item;
	item= head->item;
	head= head->link;

	return (item);
}

int IntStack::isEmpty( )
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
	Graph ( );
	void addVertex (string vertex);
	void addEdge (int fromV, int toV);
	void getAdjacent (int vertex, IntStack & adjQ);
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



void Graph::depthFirst (int StartV )
{
	IntStack mainStack, adjacentStack;
	int vertexMarked[20]={0};
	int vertex;
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




void main ( )
{
	//Create a Graph object
	Graph graph;
	string vertexName;
	char file[] = "E:\\School\\comsc210\\traverse\\datafile.txt", name[20]="0";
	ifstream inFile (file);
	int vertexNumber, startVertex, endVertex;
	
	
	//Repeatedly do the following until a negative value for a vertex is read.
	do
	{
		///////input vertex number from the file.
		inFile >> vertexNumber;
		
		///////input vertex name from the file.
		inFile.ignore();
		inFile.getline( name, 20);
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
	
	//input the start vertex.
	cout << "Please enter starting vertex: ";
	cin >> vertexNumber;
	
		graph.depthFirst (vertexNumber);
	
}

