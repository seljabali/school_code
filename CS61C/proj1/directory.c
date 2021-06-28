#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "directory.h"

#define TRUE 1
#define FALSE 0

struct entryNode {
	char * name;
	struct entryNode * next;	/* sibling */
	int isDirectory;
	struct entryNode * parent;
	union {
		char * contents;
		struct entryNode * entryList;
	} entry;
};

struct entryNode * root;

/* Helper functions */
void pwdHelper (struct entryNode *);
struct entryNode * located (char *, struct entryNode *);

/* Return an initialized file system (an empty directory named "/") 
   after storing it in the root variable. */
struct entryNode * initialFileSystem () {

    struct entryNode  * root = (struct entryNode*) malloc (sizeof(struct entryNode));
    root->name = (char*)malloc(2*sizeof(char));
    root->name = "/";
    root->next = NULL;    
    root->parent = root;
    root->isDirectory = 1;
    root->entry.entryList = NULL;
    
    return root;
}

/* implements the "create" command (one argument; not in standard UNIX) */
void createFile (struct entryNode * wd, char * fileName) { 
    struct entryNode * newFile,  * b4temp, * temp;
    int counter = 0, i = 0;
    char *text = (char*) malloc (sizeof(char));
    char c;	
	if (located (fileName, wd->entry.entryList)) {
		printf ("mkdir: %s: File exists\n", fileName);
	} else {
	    newFile = (struct entryNode*) malloc (sizeof(struct entryNode));
	    newFile->name = (char*) malloc(strlen(fileName) * sizeof(char));
	    strcpy(newFile->name, fileName);
	    newFile->parent = wd;
	    newFile->isDirectory = 0;
	    newFile->entry.contents = NULL;
	    newFile->next = NULL;
	    b4temp = NULL;
	    temp = NULL;
 
	    if(wd->entry.entryList == NULL)
	    {
		wd->entry.entryList = newFile;
		 while(1)
		 {
		     c = getchar();
	
		     if(c == '\n' && (*(text +i-1) == '\n')){
			 text = realloc(text,i+1);
			 *(text + i) = '\0';
			 break;
		     }
		     else{
			 text = realloc(text, i+1);
			 *(text+i) = c;
		     }
		     i++;
		 }
		 if (text == NULL)
		     printf("/nCouldn't allocate memory");
		 else{
		     newFile->entry.contents = (char*) malloc (strlen(text)*sizeof(char));
		     strcpy(newFile->entry.contents, text);
		 }
	    }
	    else{
	
		if(strcmp(newFile->name,(wd->entry.entryList)->name)<0){
		    newFile->next = wd->entry.entryList;
		    wd->entry.entryList = newFile;
		 while(1)
		 {
		     c = getchar();
	
		     if(c == '\n' && (*(text +i-1) == '\n')){
			 text = realloc(text,i+1);
			 *(text + i) = '\0';
			 break;
		     }
		     else{
			 text = realloc(text, i+1);
			 *(text+i) = c;
		     }
		     i++;
		 }
		 if (text == NULL)
		     printf("/nCouldn't allocate memory");
		 else{
		     newFile->entry.contents = (char*) malloc (strlen(text)*sizeof(char));
		     strcpy(newFile->entry.contents, text);
		 }
		}
		else if((wd->entry.entryList)->next == NULL)
		{
		    (wd->entry.entryList)->next = newFile;
		 while(1)
		 {
		     c = getchar();
	
		     if(c == '\n' && (*(text +i-1) == '\n')){
			 text = realloc(text,i+1);
			 *(text + i) = '\0';
			 break;
		     }
		     else{
			 text = realloc(text, i+1);
			 *(text+i) = c;
		     }
		     i++;
		 }
		 if (text == NULL)
		     printf("/nCouldn't allocate memory");
		 else{
		     newFile->entry.contents = (char*) malloc (strlen(text)*sizeof(char));
		     strcpy(newFile->entry.contents, text);
		 }
		}
	
		else{
		    b4temp = wd->entry.entryList;
		    temp  = (wd->entry.entryList)->next;		    
		    while(strcmp(newFile->name,temp->name)>0 && temp->next != NULL){
			temp = temp->next;
			b4temp = b4temp->next;
		    }
		    
		    if(strcmp(newFile->name,temp->name)<0)
		    {
			newFile->next = temp;
			b4temp->next = newFile;
			while(1)
			{
			    c = getchar();
			    
			    if(c == '\n' && (*(text +i-1) == '\n')){
				text = realloc(text,i+1);
				*(text + i) = '\0';
				break;
			    }
			    else{
				text = realloc(text, i+1);
				*(text+i) = c;
			    }
			    i++;
			}
			if (text == NULL)
			    printf("/nCouldn't allocate memory");
			else{
			    newFile->entry.contents = (char*) malloc (strlen(text)*sizeof(char));
			    strcpy(newFile->entry.contents, text);
			}
		    }
		    else
		    {
			temp->next = newFile;
					 while(1)
		 {
		     c = getchar();
	
		     if(c == '\n' && (*(text +i-1) == '\n')){
			 text = realloc(text,i+1);
			 *(text + i) = '\0';
			 break;
		     }
		     else{
			 text = realloc(text, i+1);
			 *(text+i) = c;
		     }
		     i++;
		 }
		 if (text == NULL)
		     printf("/nCouldn't allocate memory");
		 else{
		     newFile->entry.contents = (char*) malloc (strlen(text)*sizeof(char));
		     strcpy(newFile->entry.contents, text);
		 }
		    }
			 
		}  
	    }
	} 
}


/* implements the "mkdir" command (one argument; no options) */
void createDir (struct entryNode * wd, char * dirName) {
    struct entryNode * newDir, * b4temp, *temp;
	
	if (located (dirName, wd->entry.entryList)) {
		printf ("mkdir: %s: File exists\n", dirName);
	} else {
	    newDir = (struct entryNode*) malloc (sizeof(struct entryNode));
	    newDir->name = (char*) malloc(strlen(dirName) * sizeof(char));
	    strcpy(newDir->name, dirName);
	    newDir->parent = wd;
	    newDir->isDirectory = 1;
	    newDir->entry.entryList = NULL;
	    newDir->next = NULL;
	    b4temp = NULL;
	    temp = NULL;

	    /*If it is empty*/
	    if(wd->entry.entryList == NULL)
		wd->entry.entryList = newDir;
	    else{
		/*if less than first element*/
		if(strcmp(newDir->name,(wd->entry.entryList)->name)<0){
		    newDir->next = wd->entry.entryList;
		    wd->entry.entryList = newDir;
		}
		else if((wd->entry.entryList)->next == NULL)
		    (wd->entry.entryList)->next = newDir;
	
		else{
		    b4temp = wd->entry.entryList;
		    temp  = (wd->entry.entryList)->next;		    
		    while(strcmp(newDir->name,temp->name)>0 && temp->next != NULL){
			temp = temp->next;
			b4temp = b4temp->next;
		    }
		    /*Middle Node*/
		    if(strcmp(newDir->name,temp->name)<0){
			newDir->next = temp;
			b4temp->next = newDir;
			}
		    /*Last Node*/
		    else
			temp->next = newDir;
			 
		}  
	    }
	}
}

/* implements the "cd" command (one argument, which may be ".." or "/"; no options) */
struct entryNode * newWorkingDir (struct entryNode * wd, char * dirName) {
	struct entryNode * newWd;
	if (strcmp (dirName, "/") == 0) {
		return root;
	} else if (strcmp (dirName, "..") == 0) {
		return wd->parent;
	} else {
		newWd = located (dirName, wd->entry.entryList);
		if (newWd == NULL) {
			printf ("cd: %s: No such file or directory.\n", dirName);
			return wd;
		} else if (!newWd->isDirectory) {
			printf ("cd: %s: Not a directory.\n", dirName);
			return wd;
		} else {
			return newWd;
		}
	}
}

/* implements the "rm" command (one argument, unlike standard UNIX; no options) */
void removeFile (struct entryNode * wd, char * fileName) {
	struct entryNode * file, * b4temp, *temp;
	file = located (fileName, wd->entry.entryList);
	if (file == NULL) {
		printf ("rm: %s: No such file or directory.\n", fileName);
	} else if (file->isDirectory) {
		printf ("rm: %s: is a directory.\n", fileName);
	} else {
	    if(strcmp(wd->entry.entryList->name,fileName)== 0){
		temp = wd->entry.entryList;
		wd->entry.entryList = temp->next;
		free(temp);
	    }
	    else{
		b4temp = wd->entry.entryList;
		temp=wd->entry.entryList->next;
		while(strcmp(temp->name,fileName)!=0){
		    temp=temp->next;
		    b4temp=b4temp->next;
		}
		if(temp->next==NULL){
		    b4temp->next=NULL;
		    free(temp);
		}
		else{
		    b4temp->next=temp->next;
		    free(temp);
		}
	    }
	}
}

/* implements the "rmdir" command (one argument, unlike standard UNIX; no options) */
void removeDir (struct entryNode * wd, char * dirName) {
	struct entryNode * dir, * b4temp, *temp;
	
	dir = located (dirName, wd->entry.entryList);
	if (dir == NULL) {
		printf ("rmdir: %s: No such file or directory.\n", dirName);
	} else if (!dir->isDirectory) {
		printf ("rmdir: %s: Not a directory.\n", dirName);
	} else if (dir->entry.entryList != NULL) {
		printf ("rmdir: %s: Directory not empty\n", dirName);
	} else {
	    if(strcmp(wd->entry.entryList->name,dirName)== 0){
		temp = wd->entry.entryList;
		wd->entry.entryList = temp->next;
		free(temp);
	    }
	    else{
		b4temp = wd->entry.entryList;
		temp=wd->entry.entryList->next;
		while(strcmp(temp->name,dirName)!=0){
		    temp=temp->next;
		    b4temp=b4temp->next;
		}
		if(temp->next==NULL){
		    b4temp->next=NULL;
		    free(temp);
		}
		else{
		    b4temp->next=temp->next;
		    free(temp);
		}
	    }
	}
		
	      
}

/* implements the "pwd" command (no arguments; no options) */
void printWorkingDir (struct entryNode * wd) {
	if (strcmp (wd->name, "/") == 0) {
		printf ("/\n");
	} else {
		pwdHelper (wd);
		printf ("\n");
	}
}

void pwdHelper (struct entryNode * wd) {
	if (strcmp (wd->name, "/") != 0) {
		pwdHelper (wd->parent);
		printf ("/%s", wd->name);
	}
}

/* implements the "ls" command (0 or 1 argument, unlike standard UNIX; no options) */
/* Behavior is as follows:
	if no arguments, list the names of the files in wd;
	if one argument that names a text file in wd, echo the argument;
	if one argument that names a directory d in wd, list the names of the files in d;
	if one argument that names nothing in wd, print
		ls: ___: No such file or directory
 */
void listWorkingDir (struct entryNode * wd) {
	struct entryNode * p  = wd->entry.entryList;
	while (p != NULL) {
		printf ("%s\n", p->name);
		p = p->next;
	}
}

void listWithinWorkingDir (struct entryNode * wd, char * name) {
	struct entryNode * entryPtr;
	entryPtr = located (name, wd->entry.entryList);
	if (entryPtr == NULL) {
		printf ("ls: %s: No such file or directory\n", name);
	} else if (entryPtr->isDirectory) {
		listWorkingDir (entryPtr);
	} else {
		printf ("%s\n", name);
	}
}

/* implements the "cat" command (arbitrary number of arguments, which all must
   name text files; no options) */
/* This function prints the contents of a single file. */
void listFileContents (struct entryNode * wd, char * name) {
	struct entryNode * entryPtr;
	entryPtr = located (name, wd->entry.entryList);
	if (entryPtr == NULL) {
		printf ("cat: %s: No such file or directory\n", name);
	} else if (entryPtr->isDirectory) {
		printf ("cat: %s: Operation not permitted\n", name);
	} else {
		printf ("%s", entryPtr->entry.contents);
	}
}

/* Return a pointer to the entry with the given name in the given list,
   or NULL if no such entry exists. */
struct entryNode * located (char * name, struct entryNode * list) {
	if (list == NULL) {
		return NULL;
	} else if (strcmp (list->name, name) == 0) {
		return list;
	} else {
		return located (name, list->next);
	}
}
