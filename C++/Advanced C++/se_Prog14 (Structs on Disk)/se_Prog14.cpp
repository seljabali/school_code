//Name: Sami Eljabali
//Program 14 Writing Structures on disk

#include <iostream>
#include <fstream>

using namespace std;

struct record
{
  char name[15];
  double amt;
};

void main()
{
  record  master[10] = {"Helen", 10, "Julie", 20, "Lena", 30, 
                        "Alan", 40, "Annie", 50, "May", 60, 
                        "Lee",70, "Sam", 80,"June", 90, 
                        "Bill", 100};

  record  trans[7]= {"Lena",10, "Julie",5.75, "Lee",15.02, "Ed",40, 
                     "Julie",10.00, "Art",5.00, "Bill",7.32};
  record temp;

  int i;

  fstream outMaster("Master.dat", ios::out | ios::binary);
  fstream outTrans("Trans.dat", ios::out | ios::binary);

  /*WRITE*/
  for (i=0; i < 10; i++)
  {
    outMaster.write((char *) &master[i], sizeof(record));
  }

  for (i=0; i < 7; i++)
  {
    outTrans.write((char *) &trans[i], sizeof(record));
  }
  
  outMaster.close();
  outTrans.close();

  /*READ*/
  fstream fin ("Master.dat", ios::in | ios::binary);
  fstream fin2("Trans.dat",  ios::in | ios::binary);

  cout << "Master record: \n\n";
  while (fin.read((char *) &temp, sizeof(record)))
  {
    cout << temp.name << '\t' << temp.amt << endl;
  }

  cout << "\nTrans record: \n\n";

  while (fin2.read((char *) &temp, sizeof(record)))
  {
    cout << temp.name << '\t' << temp.amt << endl;
  }
  
  cin.get();
}