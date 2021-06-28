#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

int main() {
	int num;
	int *ptr;
	int **handle;

	/* Describe (either as comments in this file or a separate document) the
	   effect of each of the following statements.  What areas of memory (heap or
	   stack) are affected bt the statement?  Does any memory get allocated or
	   freed?  If so, where is this memory?  Does the statement result in a
	   memory leak? 
	   
	   Feel free to use gdb or printf statements to help in your investigation.
	
	   Additionally, both of the malloc statements work, but one of them is
	   in bad form.  Which is "bad," why is it "bad," and how would you change it?
	 */
	 
	 num = 14;
	 ptr = (int *)malloc(2 * sizeof(int));
	 handle = &ptr;
	 *ptr = num;
	 ptr = &num;
	 handle = (int **)malloc(1 * sizeof(int *));
}
