/*
 *Sami Eljabali 
 *Assignment #10
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
	int path [20];
	int pathlen;	
};	

void Graph::MinPath (int from, int to)
{

	//ItemQue is a priority que that queus ItemType items.
	//IntQue is a regular que that queues ints. 
      //It’s used to store adjacent vertices.
	ItemQue mq;
	IntQue adjq;
	ItemType item;
	Enque the start vertex item in the PmainQ.  
	While ( !( PmainQ.isEmpty() ) )
	{
          Deque a vertex item from the PmainQ.
	//Process the vertex item dequeued as follows.
	if( vertex is unmarked )
	{
	If (vertex is the target vertex )
		break from the loop;
	Mark the vertex as visited.
	getAdjacent (vertex, adjacentQ)
 
    //Process the adjacent vertices by dequeing them from the adjacent queue 
	//and enqueueing them in PmainQ as below.
    While ( !( adjacentQ.isEmpty() ) )
	{
		Dequeue a vertex from adjacentQ.
		If( adjacent vertex is unmarked )
		{
			Enqueue the adjacent vertex item in the PmainQ.
		}
    Enque the start vertex item in the PmainQ.  
	While ( !( PmainQ.isEmpty() ) )
	{
          Deque a vertex item from the PmainQ.
 
		//Process the vertex item dequeued as follows.
		If( vertex is unmarked )
		{
          If ( vertex is the target vertex )
                   break from the loop;
 
	Mark the vertex as visited.
 
	//Get a list of all its adjacent vertices by calling a method (say getAdjacent ) as below.
	//(Note: getAdjacent returns adjacent vertices in a queue, adjacentQ, passed to it as below).
	//(Note: getAdjacent returns vertices in order with the lowest numbered vertex first).                                                                                                            
 
          getAdjacent (vertex, adjacentQ)
	//Process the adjacent vertices by dequeing them from the adjacent queue 
	//and enqueueing them in PmainQ as below.
          While ( !( adjacentQ.isEmpty() ) )
          {
			Dequeue a vertex from adjacentQ.
			If( adjacent vertex is unmarked )
			{
				Enqueue the adjacent vertex item in the PmainQ. 
			}
          }
         }
}

	int p_vertex; //parent vertex # (i.e. the vertex just dequeued).
	int p_dist; //total distance of the parent vertex from the start vertex.
	int p_pathlen;//the length of the occupied part of the path array i.e.
                   //the length of path.
	

    int adjver; //a vertix 

	int marked [20]; //array to keep track of which vertices are marked.

	//unmark all vertices. 
	for (int i=0;i<20;i++)
		marked[i] = 0;

	//prepare the first item to be queued.

      //Initialize the path array to be all zeros.
	for (int i=0;i<20;i++)
		item.path[i] = 0;
      
      //set the distance of the start vertex to the start vertex to be 0.
	item.dist = 0; //its distance from from start vertix.

	//set the path of the start vertex to the start vertex to contain
      //the start vertex.

	item.path[0] = from; //first entry in the vertix array list.

	//set the path length to be 1 because there is only one vertex in
      //the path.
      item.pathlen = 1;

	

	

	//enque the item in the priority queue
	//we enque this to get the algorithm started
      //we will soon deque it and then enque its adjacents (i.e.children).
	
       mq.penque (item);

	//start the deque/enque loop

	while (!(mq.isEmpty()))
	{
		//Deque the item. 
		mq.dequeue (item);


		//break if target is reached.
		if (item.path[item.pathlen-1] == item)
			break;

            //Save its values (call them parent values. These will be needed
		//to generate (child) next level items
		
            //For this purpose, 
            //Save the distance of this vertex from the start vertex.
            //Save the vertex number of this vertex. This vertex is the
            //last vertex in the path list.
            //Save the path length.

		//We save them here because the variable item will be reused
		//preparing a next level item.
		
		p_dist = item.dist;
		p_vertex = item.path[item.pathlen-1];
		p_pathlen = item.pathlen;


		//if the item is not yet marked. find the next level items.
		if(marked[item.path[pathlen-1]] == 0 )
		{
			//mark the item
			marked[item.path[item.pathlen-1]] = 1;

			//Find the next level vertices. receive them in an int que
			//Call method findAdj and pass it an int queue.
                  //findAdj method will return list of adjacent (child) 
                  //vertices in the int queue passed to it. 
			
			findAdj (item.path[item.pathlen-1], adjq);

			//enque next level items in the priority que
			while (!(adjq.isEmpty()))
			{
				//deque a next level (i.e. child) vertex
				//the vertix number of one of the next level vertices
                        // will be returned in an int vertex 
				adjq.deque (adjver);

				//if the next level vertix is not marked. 
				//Prepare an item for it and 
                        //enque the item in the priority queue
				//Use the same item variable as above. 
                        //But modify it as below.

				if (marked[adjver] == 0)
				{
					//prepare an item for it by
					//reusing the item variable.

					//calculate its accumulated distance.
					item.dist = pdist + edges [p_vertex][adjver];

					//add the vertex to the path list in the item
					item.path[p_pathlen] = adjver;

					//update the length of the used verix array list
					item.pathlen = p_pathlen + 1;

					//enque the item in the priority que
					mq.penque (item);
				}
			}
		}
	}

	cout << "Min Path: " << item.dist;
}
