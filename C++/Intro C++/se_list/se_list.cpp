/************************************************************************************************ 
			   FILE:	se_list.cpp 
			   AUTHOR:  Sami Eljabali 
			   PURPOSE: to read in five integers and store them into an array then the program 
						will sort it. then it will display some options for the user to do with 
						the array.Search,Insert, or delete a number from the list. 
			   DATE:	11/10/2003 
			   INPUT:	Five integers. Then an option from the list. 
			   OUTPUT:  Display the five integers sorted. then display the result of option the 
						user has chosen 
 ************************************************************************************************/ 
#include <iostream>
 
using namespace std; 

void Sort(int[]),
     DisplayArray(int[], int& ),
     BinarySearch(int[], int&),
     Insert(int [], int&),
     Delete(int[], int&);
 
int main()
{ 
	int array[5], 
        length = 5,
        temp = 0; 
		  
	
	bool found = true;

	cout << "Please enter five random numbers: "; 
	
	
	//Input 
	for( length = 0; length <= 4; length++ ) 
		cin >> array[length]; 


	//Display the array unsorted 
	cout << endl << "The five numbers not sorted: " << endl; 
	DisplayArray(array, length); 


	//Sorting 
    Sort(array);
  

	//Output 
	cout << endl << "The five numbers sorted: " << endl; 
	DisplayArray(array, length);
	
	while (true) 
	{ 
		//Displaying options 
		cout << endl << "1)Display the list" 
             << endl << "2)Search for a specific number in the list"
             << endl << "3)Insert a number into the list" 
		  	 << endl << "4)Delete a number from the list" 
		   	 << endl << "5)Exit program" << endl 
		  	 << endl << "Choose one of the options: "; 
		cin >> temp; 

		switch (temp) 
		{ 
			case 1: cout << endl;
                    DisplayArray(array, length); 
                    break; 

			case 2: BinarySearch(array, length); 
                    break; 

			case 3: Insert(array, length); 
                    break; 

			case 4: Delete(array, length); 
                    break; 

			case 5: return 0;
				    break;

			default: cout << endl << "Invalid option." << endl; 
		} 
	} 

} 
                    /************************************** 

               *******************FUNCTIONS************************ 

                     **************************************/ 





//DISPLAYING
void DisplayArray(int array[], int& length) 
{ 
	int temp;
	
  if (length == 0)

   cout << "List is empty." << endl;
   
  else
  {

	  for(temp = 0; temp < length; temp++) 
	  { 
		  cout << temp << ")" 
		       << array[temp]
		       << endl; 
	  }

  }
} 


//BINARY SEARCHING
void BinarySearch(int array[], int &length) 
{ 

	int item = 0, 
		first = 0, 
		last = length, 
		poisition = 0,
		middle; 

	bool found;

	cout << endl << "Please enter a number to search for: "; 
	cin >> item; 
	
	found = false; 
	while(last >= first && !found) 
	{ 
		middle = (first + last)/2;
		
		if (item < array[middle]) 
			last = middle - 1; 

		else if(item > array[middle]) 
			first = middle +1; 

		else if (item > array[middle]) 
			first = middle +1; 

		else 
			found = true; 
	}
	
	if (found) 
	{
		poisition = middle; 
		cout << endl << "The number " << item << " is at index " << poisition << "." << endl;
	}
	else
	{
		cout << endl << "The number " << item << " was not found." << endl; 

	}

}

//INSERT
void Insert(int array[], int &length)
{
	int index = 0,
        item = 0;

	if (length > 4)

		cout << endl << "The list is full!" << endl;

	else
	{
		cout << endl << "Please enter a numer to insert: ";
		cin >> item;

		index = length - 1;
		while(index >=0 && item < array[index])
		{

			array[index+1] = array[index];
			index--;
 
		}

		array[index+1] = item;
		length++;

    }
  Sort(array);

}

//DELETE
void Delete(int array[], int &length)
{
	int last = length,
        first = 0,
        middle = 0,
        item = 0,
        index = 0;
	
	bool found;

  
  if (length <= 0)
  
	  cout << endl << "List is empty" << endl;
  
  else
  {

    cout << endl << "Please enter a number to delete: ";
	cin >> item;

	//search
	found = false; 
	while(last >= first && !found) 
	{ 
		middle = (first + last)/2;
		
		if (item < array[middle]) 
			last = middle - 1; 

		else if(item > array[middle]) 
			first = middle +1; 

		else if (item > array[middle]) 
			first = middle +1; 

		else 
			found = true; 
	}


	if (found)
	{
       for (index = middle; index < length - 1; index++)
	        array[index] = array[index+1];
		
	   length--;

	}
	else
		cout << endl << "The number was not found." << endl;

    Sort(array);
  }
}

//SORT
void Sort(int array[])
{
  int temp,
      counter,
      minIndex, 
      searchIndex;
      
	for(counter = 0; counter < 4; counter++) 
	{ 

		minIndex=counter; 

		//Finding smallest 
		for( searchIndex = counter + 1; searchIndex < 5; searchIndex++ ) 
			if( array[searchIndex] < array[minIndex] ) 
				minIndex = searchIndex; 

		//Swaping 
		temp = array[minIndex]; 
		array[minIndex] = array[counter]; 
		array[counter] = temp; 

	} 

}
