//File:		  se_stateadmissionsloop.cpp
//Purpose:	  to read mulitiple student applications from a file.Then determine if the student 
//		  is accepted based on class ranking and SAT scores. then copy output to a file	
//Author:	  Sami Eljabali
//Date:		  6/9/03
//Input:	  The file (a\:Fileio.in)
//Output:	  Name, Last name, Sat score, class ranking, status (accepted or not), if so 
//                then what category was he in, in acceptance. If not then where did he/she go
//	          wrong. To both screen and to Fileio.out
//Description:
//
//   Algorithm:		
//	
//	    Read intput file Fileio.in then
//              
//          Check if SAT and HSR are valid else display Error message under its menu
//          If SAT <0 or SAT >1600 
//          then exit program
//          
//          If HSR <0 or HSR > 100
//          then exit program
//
//          *Check which category and what is the stundent's status          
//          If  HSR >=90 and HSR <=100 
//          status = "Accepted"
//		      Then category = 1
//              
//          Else If (SAT >=1440 and SAT <=1600) and (HSR >=30 and HSR<=100)	
//		      status = "Accepted"
//              	Then category = 2
//              
//          Else If  (SAT >=1280 and SAT <=1600) and (HSR >=60 and <=100)
//          status = "Accepted"
//		      Then category = 3
//              
//          Else If  (SAT >=1120 and SAT <=1600) and (HSR >=85 and <=100)
//          status = "Accepted"
//		      Then category = 4
//              
//          Else If HSR < 85 
//		      status = "Not Accepted"
//		      then category = "HSR"
//              
//          Else If SAT < 1120 
//		      status = "Not Accepted"
//		      then category = "SAT"
//              
//          *Display Fullnames, Sat scores, class rankings, statuss (accepted or not), 
//          if so then what category was he/she in, in acceptance. If not then where did he/she 
//          go wrong.To both screen and to Fileio.out



#include <iostream>
#include <string>
#include <iomanip>
#include <fstream>
using namespace std;

int main()
{
    string Firstname, 	//Input First name
           Lastname,  	//Input last name
           Fullname,  	//Output First + Lastname
           Status,    	//Output Status
           Category,  	//Output category
           strSAT,
           strHSR;
    
    int HSR,      	//Input High School Ranking
        SAT;      	//Input SAT score

    ifstream inFile;	//Input File
    ofstream outFile;	//Output File
      
        
    //Open input file
    inFile.open("C:\\Cool\\C++\\State Admissions Loop\\Fileio.in");        
    if (!inFile)
    {
      cout << "Could not open input file." << endl;
      cin.get();
      cin.get();
      return 0;
    }

    //Open output file
    outFile.open("C:\\Cool\\C++\\State Admissions Loop\\Fileio.out");
    if (!outFile)
     {
       cout << "Could not open output file." << endl;
       cin.get();
       cin.get();
       return 0;
     }

    //Display Name,Last name,Sat score,class ranking, status (accepted or not), and category
    cout << endl;
    outFile << endl;
    cout << setw(8) << "Name";
    outFile << setw(8) << "Name";
    cout << setw(19) << "SAT Score";
    outFile<< setw(19) << "SAT Score";
    cout << setw(10) << "HS Rank";
    outFile << setw(10) << "HS Rank";
    cout << setw(12) << "Status"; 
    outFile << setw(12) << "Status"; 
    cout << setw(17) << "Category" << endl;
    outFile << setw(17) << "Category" << endl;

    cout << setw(8)  << "----";
    outFile << setw(8)  << "----";
    cout << setw(19) << "---------";
    outFile << setw(19) << "---------";
    cout << setw(12) << " --------- ";
    outFile << setw(12) << " --------- ";
    cout << setw(10) << "------";
    outFile << setw(10) << "------";
    cout << setw(17) << "--------"<< endl << endl ;
    outFile << setw(17) << "--------"<< endl << endl ;

    //Reading data from input file    
    inFile >> Firstname >> Lastname >> SAT >> HSR;

    while (inFile)
    {
      strHSR = "";
      strSAT = "";
      //Determinating whether the data is valid or not
      if (SAT < 0 || SAT > 1600)
      
        strSAT = "Error";

      if (HSR < 0 || HSR > 100)
      
        strHSR = "Error";

        //Check which category and what is the stundent's status
        if  (HSR >=90)
        {
          Category = "1";
          Status = "Accepted";
         }
    
        else if (SAT >= 1440 && HSR >=30)
        {
          Category = "2";
          Status = "Accepted";
        }
    
        else if (SAT >= 1280 && HSR >= 60)
        {
          Category = "3";
          Status = "Accepted";
        }
    
        else if (SAT >= 1120 && HSR >= 85)
        {
          Category = "4";
          Status = "Accepted";
        }
    
        else if (HSR < 85)
          Category = "HSR";
          
        else if (SAT < 1120)
          Category = "SAT";

      Fullname = Lastname + ", " + Firstname;


    
      //First category
      if (Category == "1")
      {
        if (strSAT == "Error" && strHSR == "Error")
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          cout << setw(6) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(6) << "n/a" << setw(16) << "n/a" << endl;	
        } 
        else if (strHSR == "Error" )
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          cout << setw(9) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(9) << "n/a" << setw(16) << "n/a" << endl;	
        }
        else if (strSAT == "Error")
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          cout << setw(16) << "Accepted" << setw(12) << "1" << endl;
	        outFile << setw(16) << "Accepted" << setw(12) << "1" << endl;	
        }

        else
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << setw(10) << HSR;
          outFile << right << SAT << setw(10) << HSR;
          cout << setw(16) << "Accepted" << setw(12) << "1" << endl;
	        outFile << setw(16) << "Accepted" << setw(12) << "1" << endl;	
        }
      }

      //Second Category
      else if (Category == "2")
      {
        if (strSAT == "Error" && strHSR == "Error")
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          cout << setw(6) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(6) << "n/a" << setw(16) << "n/a" << endl;	
        } 

        else if (strHSR == "Error") 
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          cout << setw(9) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(9) << "n/a" << setw(16) << "n/a" << endl;	
        }
  	    else if (strSAT == "Error")
	    {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          cout << setw(13) << "n/a" << setw(15) << "n/a" << endl;
          outFile << setw(13) << "n/a" << setw(15) << "n/a" << endl;
        }

	    else
	    {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << setw(10) << HSR;
          outFile << right << SAT << setw(10) << HSR;
          cout << setw(16) << "Accepted" << setw(12) << "2" << endl;
          outFile << setw(16) << "Accepted" << setw(12) << "2" << endl;
	    }
     }

      //Third Category
      else if (Category == "3")
      {
        if (strSAT == "Error" && strHSR == "Error")
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          cout << setw(6) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(6) << "n/a" << setw(16) << "n/a" << endl;	
        } 

        else if (strHSR == "Error") 
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          cout << setw(9) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(9) << "n/a" << setw(16) << "n/a" << endl;	
        }
  	    else if (strSAT == "Error")
	      {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          cout << setw(13) << "n/a" << setw(15) << "n/a" << endl;
          outFile << setw(13) << "n/a" << setw(15) << "n/a" << endl;
        }

	    else
	    {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << setw(10) << HSR;
          outFile << right << SAT << setw(10) << HSR;
          cout << setw(16) << "Accepted" << setw(12) << "2" << endl;
          outFile << setw(16) << "Accepted" << setw(12) << "2" << endl;
	    }
      }

      //Fourth Category
      else if (Category == "4")
      {
        if (strSAT == "Error" && strHSR == "Error")
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR << "(" << strHSR << ")";
          cout << setw(6) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(6) << "n/a" << setw(16) << "n/a" << endl;	
        } 

        else if (strHSR == "Error") 
        {
          cout << setw(20) << left << Fullname;
          outFile << setw(20) << left << Fullname;
          cout << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          outFile << right << SAT << setw(7) << HSR << "(" << strHSR << ")";
          cout << setw(9) << "n/a" << setw(16) << "n/a" << endl;
	        outFile << setw(9) << "n/a" << setw(16) << "n/a" << endl;	
        }
  	    else if (strSAT == "Error")
	      {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          outFile << right << SAT << "(" << strSAT << ")" << setw(3) << HSR;
          cout << setw(13) << "n/a" << setw(15) << "n/a" << endl;
          outFile << setw(13) << "n/a" << setw(15) << "n/a" << endl;
        }

        else
	      {
          cout << setw(20) << left << setw(20) << Fullname;
          outFile << setw(20) << left << setw(20) << Fullname;
          cout << right << SAT << setw(10) << HSR;
          outFile << right << SAT << setw(10) << HSR;
          cout << setw(16) << "Accepted" << setw(12) << "2" << endl;
          outFile << setw(16) << "Accepted" << setw(12) << "2" << endl;
	      }
      }

      //Not Accepted due to HSR
      else if (HSR < 85)
      {
        cout << setw(20) << left << setw(20) << Fullname;
        outFile << setw(20) << left << setw(20) << Fullname;
        cout << right << SAT << setw(10) << HSR;
        outFile << right << SAT << setw(10) << HSR;
        cout << setw(18) << "Not Accepted" << setw(11) << "HSR" << endl;     
        outFile << setw(18) << "Not Accepted" << setw(11) << "HSR" << endl;     
      }

      //Not Accepted due to SAT score
      else if (SAT < 1120)
      {
        cout << setw(20) << left << setw(20) << Fullname;
        outFile << setw(20) << left << setw(20) << Fullname;
        cout << right << SAT << setw(10) << HSR;
        outFile << right << SAT << setw(10) << HSR;
        cout << setw(18) << "Not Accepted" << setw(11) << "SAT" << endl;
        outFile << setw(18) << "Not Accepted" << setw(11) << "SAT" << endl;
      }
      
      inFile >> Firstname >> Lastname >> SAT>> HSR;
    }
cin.get();
inFile.close();
outFile.close();
return 0;

}