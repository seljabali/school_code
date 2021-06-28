/*Name: Sami Eljabali
  Program 15 Updating Random Access Files*/
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

struct record
{
  char name[15];
  double amt;
};

int main()
{
  
  int found;
  record tempMas, tempTrans;
  
  /*Openning files*/
  fstream inMaster  ("Master.dat",  ios::in |ios::binary);
  fstream outMasterC("MasterC.dat", ios::out|ios::binary);
  fstream inTrans   ("Trans.dat",   ios::in |ios::binary);
  
  /*Printing Master before update*/
  cout << "Master before update:\n"
       << "=====================\n";
  while (inMaster.read((char*)&tempMas,sizeof(record)))
  {
    cout << tempMas.name<< "\t" << tempMas.amt << endl;
    outMasterC.write((char*)&tempMas, sizeof(record));
  }    

  inMaster.close();
  outMasterC.close();
  fstream ioMasterC;
  ioMasterC.open("MasterC.dat",ios::in|ios::out|ios::binary);

  /*Printing Trans before update*/
  cout << "\n\nTrans before update:\n"
       <<     "====================\n";  
  while ( inTrans.read((char*)&tempTrans,sizeof(record)) )
  {
    cout << tempTrans.name<< "\t" << tempTrans.amt << endl;
    ioMasterC.seekg(0,ios::beg);
    found = 0;
    while ( ioMasterC.read((char*)&tempMas,sizeof(record)) )
    {
	    /*Comparing*/
      if ( !strcmp( tempTrans.name,tempMas.name ) )
      {
        ioMasterC.seekg( -sizeof( record ),ios::cur);
        tempMas.amt += tempTrans.amt;
        ioMasterC.write((char*)&tempMas, sizeof(record));
        found = 1;
        break;
      }
    }

  	/*If not found: Append*/
    if ( found == 0 )
    {
      ioMasterC.seekg(0,ios::end);
      ioMasterC.clear();
      ioMasterC.write((char*)&tempTrans,sizeof(record));
    }
    ioMasterC.clear();
  }

  /*Printing Master after update file*/
  cout << "\nMaster after update:\n"
       << "======================\n";
  ioMasterC.seekg(0,ios::beg);
  while ( ioMasterC.read((char*)&tempMas,sizeof(record)) )
  {
    cout << tempMas.name << '\t' << tempMas.amt << endl;
    ioMasterC.clear();
  }
  cin.get();
  return 0;
}