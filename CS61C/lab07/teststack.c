/*********************************************************************
teststack.c

This file implements a main function that runs some simple tests on
the stack data structure defined in stack.h and stack.c.  This is not
meant to be a useful test of the stack.  Instead, it is just going to
be used to demonstrate linker and object file features.

**********************************************************************/

/* Include the definitions for the stack data structure */
#include "stack.h"

int main () {
    /* Initiailize some values to test the stack */
    int value1 = 7;
    int value2 = 2;

    /* Initialize the stack and get a pointer to it */
    Stack s = EmptyStack();

    /* play with the stack */
    Push(s, value2);
    
    if (IsEmpty (s)) {
	Push (s, value1);
    } else {
	value1 = Pop(s);
    }

    return 0;
}
