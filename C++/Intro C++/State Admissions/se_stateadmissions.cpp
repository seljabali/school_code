//File:		  se_stateadmissions.cpp
//Purpose:	to see if a student will be accepted based on class ranking and SAT scores	
//Author:	  Sami Eljabali
//Date:		  6/9/03
//Input:	  Name, Last name, Sat score, and class ranking respectively by the keyboard
//Output:	  Name, Last name, Sat score, class ranking, status (accepted or not), if so 
//          then what category was he in, in acceptance. If not then where did he/she go
//			    wrong.
//Description:
//
//   Algorithm:		
//		    *Prompt user to enter full name, SAT score, and class ranking(HSR)
//          
//          *Check if SAT and HSR are valid else terminate program
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
//          *Display Name, Last name, Sat score, class ranking, status (accepted or not), 
//          if so then what category was he in, in acceptance. If not then where did he/she 
//          go wrong.



#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

int main()
{
    string Firstname, //Input First name
           Lastname,  //Input last name
           Fullname,  //Output First + Lastname
           Status,    //Output Status
           Category;  //Output category
    
    int HSR,      //Input High School Ranking
        SAT;      //Input SAT score
    
    //Prompt user to enter full name, SAT score, and class ranking(HSR)
    cout << "Please enter your first name:";
    cin >> Firstname;

    cout << "Please enter your last name:";
    cin >> Lastname;

    cout << "Please enter your SAT score out of 1600:";
    cin >> SAT;
    
      //Check if SAT and HSR are valid else terminate program
      if (SAT > 1600 || SAT <0)
      {
        cout << "Please enter vaild SAT score (0-1600)";
        cin.get();
        cin.get();
        return 0;
      }
    
      cout << "Please enter your high school ranking out of 100:";
      cin >> HSR;
    
      if (HSR > 100 || HSR <0)
      {
        cout << "Please enter vaild High School Ranking (0-100)";
        cin.get();
        cin.get();
        return 0;
      }

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

    //Display Name,Last name,Sat score,class ranking, status (accepted or not), and category
    cout << endl;
    cout << setw(8) << "Name"; 
    cout << setw(19) << "SAT Score";
    cout << setw(10) << "HS Rank";
    cout << setw(12) << "Status"; 
    cout << setw(17) << "Category" << endl;
  
    cout << setw(8)  << "----";
    cout << setw(19) << "---------";
    cout << setw(12) << " --------- ";
    cout << setw(10) << "------";
    cout << setw(17) << "--------"<< endl << endl ;
      
          //First category
          if (HSR >= 90)
          {
            cout << setw(20) << left << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(16) << "Accepted" << setw(12) << "1" << endl;
          }
      
          //Second Category
          else if (SAT >= 1440 && HSR >=30)
          {
            cout << setw(20) << left << setw(20) << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(16) << "Accepted" << setw(12) << "2" << endl;
          }
      
          //Third Category
          else if (SAT >= 1280 && HSR >= 60)
          {
            cout << setw(20) << left << setw(20) << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(16) << "Accepted" << setw(12) << "3" << endl;
          }

          //Fourth Category
          else if (SAT >= 1120 && HSR >= 85)
          {
            cout << setw(20) << left << setw(20) << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(16) << "Accepted" << setw(12) << "4" << endl;
          }

          //Not Accepted due to HSR
          else if (HSR < 85)
          {
            cout << setw(20) << left << setw(20) << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(18) << "Not Accepted" << setw(13) << "HSR" << endl;     
          }

          //Not Accepted due to SAT score
          else if (SAT < 1120)
          {
            cout << setw(20) << left << setw(20) << Fullname;
            cout << right << SAT << setw(10) << HSR;
            cout << setw(18) << "Not Accepted" << setw(13) << "SAT" << endl;
          }

cin.get();
cin.get();
return 0;

}