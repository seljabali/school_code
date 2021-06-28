/*
 *Sami Eljabali 
 *Assignment #11
 */
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

struct NodeType;
typedef NodeType * NodePtr;

struct ItemType;

struct NodeType
{
	int dist; 
	int path [20];
	int pathlen; 
	ItemType link;
};


struct ItemType
{
	int dist;
	int path [15];
	int pathlen;	
};

void getNextSquares (int square, IntQue & q)
{
      int nextSquare;
      int row = square / 4;
      int col = square % 4;

      //upward moves
      if (row - 2 >= 0 && col + 1 <= 3)
      {
               nextSquare = square - 7;
               q.enque (nextSquare);
      }
      if (row - 2 >= 0 && col - 1 >= 0)
      {
               nextSquare = square - 9;
               q.enque (nextSquare);
      }
      if (row - 1 >= 0 && col + 2 <= 3)
      {
               nextSquare = square - 2;
               q.enque (nextSquare);
      }
      if (row - 1 >= 0 && col - 2 >= 0)
      {
               nextSquare = square – 6;
               q.enque (nextSquare);
      }

	  //downward moves
      if (row + 2 <= 3 && col + 1 <= 3)
      {
               nextSquare = square + 9;
               q.enque (nextSquare);
      }
      if (row + 2 <= 3 && col - 1 >= 0)
      {
               nextSquare = square + 7;
               q.enque (nextSquare);
      }
      if (row + 1 <= 3 && col + 2 <= 3)
      {
               nextSquare = square + 6;
               q.enque (nextSquare);
      }
      if (row + 1 <= 3 && col - 2 >= 0)
      {
               nextSquare = square + 2;
               q.enque (nextSquare);
      }        
}
void Graph::MinPath (int from, int to)
{

	//ItemQue is a priority que that queus ItemType items.
	//IntQue is a regular que that queues ints. 
    //It's used to store adjacent vertices.
	ItemQue mq;
	IntQue adjq;
	ItemType item;
	Enque the start vertex item in the PmainQ.  
	While (!( PmainQ.isEmpty()))
	{
          PmainQ.Deque(item);
	//Process the vertex item dequeued as follows.
	if( vertex is unmarked )
	{
	If (vertex is the target vertex )
		break from the loop;
	Mark the vertex as visited.
	getAdjacent (vertex, adjacentQ)
 
      //Process the adjacent vertices by dequeing them from the   
     //and enqueueing them in PmainQ as below.
     While ( !( adjacentQ.isEmpty() ) )
	{
		adjacentQ.deque(item);
		If( adjacent vertex is unmarked )
		{
			PmainQ.Enqueue(adjacentq.deque);
   		}
     	PmainQ.enque(start);  
	While ( !( PmainQ.isEmpty()))
	{
		PmainQ.deque(item); 
		//Process the vertex item dequeued as follows.
		if( vertex.value == -1)
		{
          If (vertex.value == item)
                   break;
	}

 
	Mark the vertex as visited.
	//Get a list of all its adjacent vertices by calling a method 
	//(Note: getAdjacent returns adjacent vertices in a queue, 
          getAdjacent (vertex, adjacentQ)
	//Process the adjacent vertices by dequeing them from the 
    While ( !( adjacentQ.isEmpty()))
    {
		djacentQ.deque;
		If( adjacentq.deque)
		{
			PmainQ.Enqueue(adjacentq.deque);
		}
	}
}
void main()
{
	int start, end;
 
	cout << "Enter starting postion: " << endl;
	cin start;
	cout << "Enter ending position: " << endl;
	cin end;
	ifstream Data ("datafile.txt");	
	RecType r; 
	char action;

	finMaster >> r.id;
	while (!data.eof())
	{
		data >> poisitions;
	} 

	minpath(start, end);
	cout << "Shortest Sequence of Moves: " << endl 

}