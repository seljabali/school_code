/*FILE:		  se_salary.cpp
 *PURPOSE:	  to read in input of workers weekly sales, workers number of hours worked that week
 *     		  and finally the number of dependents from a file. then determine which plan is 
 *	          better for the worker.write to a file the wage if the workers plan was under A and B
 *			  then state which whould suite him/her. Display the how much must the worker
 *            pay for social security, state income tax, federal tax, health insurance, union dues
 *            and finally how much is left of the salary, this is also copied to a file.	
 *AUTHOR:     Sami Eljabali
 *DATE:		  10/5/03
 *INPUT:      The file (a\:salary.in)
 *OUTPUT:  	  Display the how much must the worker pay for social security, state income
 *            tax, federal tax, health insurance, union dues and finally how much is left of the
 *            salary to both the screen and to (a:\salary2.out)
 *DESCRIPTION:  
 *
 * ALGORITHM: Read data from file (a:\salary.in)
 *			  
 *		Call function GetInput() to get data from file
 *      Read in data from Salary.in
 *
 *		Call PrintHeading to print the heading of both fileouput and screen
 *			           
 *      Call CalculateGrossA() Calculate how much would worker make if he/she was in plan A	
 *      If Hours <= 40 Then
 *        Gross = (TotalSales * 0.10) + (8.25 * Hours)
 *      Else
 *        Gross = (TotalSales * 0.10) + (8.25 * 40) + (12.75 * (Hours - 40))
 *		  
 *		Call CalculateGrossB() Calculate how much would worker make if he/she was in plan B
 *      Gross = TotalSales * 0.25
 *
 *      If A>B Then (IN MAIN)
 *        Gross = A
 *      Else 
 *        Gross = B
 *			  
 *      CalculateSocialSecurity() Calculate how much must the worker pay for Social Security
 *			  SocialSecurity = (Gross * 0.06)
 *
 *		CalculateStateTax() Calculate how much the worker should pay for Social Security
 *			  StateTax = (Gross *0.08)
 *
 *      CalculateFedTax() Calculate how much the worker should pay for Federal Tax
 *			  FedTax = (Gross * 0.12)
 *
 *      CalculateNet() Calculate how much the worker has left from his/her salary
 *			If Dependent >= 3 Then
 *			  netPay = Gross - SocialSecurity - StateTax - FedTax - HealthInsurance - Union
 *			Else
 *			  netPay = Gross - SocialSecurity - StateTax - FedTax - Union
 *
 *      PrintPayAndDeductions() Print much the worker will pay for social security, state 
 *			  income tax, federal tax, health insurance, union dues and finally how much is left 
 *			  of the salary to both the screen and to (a:\salary.out)
 */


#include <iostream>
#include <iomanip>
#include <fstream>

using namespace std;

void GetInput(ifstream &inSalary, float &totalSales, int &hoursWorked, int &numDependents),
     PrintHeading(ofstream &outSalary, ofstream &outSalary2),
     PrintPayAndDeductions (ofstream &outSalary,ofstream &outSalary2, float grossPay,float 
							grossPayA,float grossPayB, float SocialSecurity,float stateIncomeTax,
							float fedIncomeTax,float netPay, int numDependents);

			
float CalculateGrossPayA(float totalSales, int hoursWorked),
	  CalculateGrossPayB(float totalSales),
	  CalculateSocialSecurity(float payGross),
	  CalculateStateTax(float payGross),
	  CalculateFedTax(float payGross),
	  CalculateNetPay(float grossPay, float SocialSecurity, float stateIncomeTax,
					  float fedIncomeTax, int numDependents);

const float UnionDues = 6.00,
			HealthInsurance = 10.00;

int main()
{
  ifstream inSalary;	
  ofstream outSalary,	
		   outSalary2;

  int	hoursWorked,
	    numDependents;

  float	 totalSales,
	     grossPayA,
		 grossPayB,
		 grossPay,
	     SocialSecurity,
	     stateIncomeTax,
	     fedIncomeTax,
		 netPay;
  

   hoursWorked = 0;
   totalSales = 0;
   numDependents = 0;
	
    inSalary.open("C:\\Cool\\C++\\Salary\\salary.in");        
    if (!inSalary)
    {      
	    cout << "Could not open input file!" << endl;
		cin.get();
		return 0;
    }
   
 	  outSalary.open("C:\\Cool\\C++\\Salary\\salary.out");        
    if (!outSalary)
    {      
	    cout << "Could not open input file!" << endl;
		cin.get();
		return 0;
    }
	
	  outSalary2.open("C:\\Cool\\C++\\Salary\\salary2.out");        
    if (!outSalary2)
    {      
	    cout << "Could not open input file!" << endl;
		cin.get();
	    return 0;
    }  
   
   //Input
   GetInput(inSalary, totalSales, hoursWorked, numDependents);
   
   PrintHeading(outSalary, outSalary2);
   
   while (inSalary)
   {
	  //Process
	  grossPayA = CalculateGrossPayA(totalSales, hoursWorked);
	  
	  grossPayB = CalculateGrossPayB(totalSales);

	  if (grossPayA > grossPayB)
		  grossPay = grossPayA;
	  else
		  grossPay = grossPayB;

	  SocialSecurity = CalculateSocialSecurity(grossPay);

	  stateIncomeTax = CalculateStateTax(grossPay);

	  fedIncomeTax = CalculateFedTax(grossPay);

	  netPay = CalculateNetPay(grossPay, SocialSecurity, stateIncomeTax, fedIncomeTax, 
							  numDependents);

	  //Output
	  PrintPayAndDeductions (outSalary,outSalary2, grossPay, grossPayA, grossPayB, SocialSecurity, 
						     stateIncomeTax, fedIncomeTax, netPay, numDependents);
 
	  GetInput(inSalary,totalSales,hoursWorked,numDependents);

   }
	inSalary.close();
	outSalary.close();
	outSalary2.close();
	cin.get();
	return 0;
}

					/*****************************/
					/*****************************/
					/**********FUNCTIONS**********/
					/*****************************/
					/*****************************/


void GetInput(ifstream &inSalary, float &totalSales, int &hoursWorked, int &numDependents)
{

	inSalary >> totalSales >> hoursWorked >> numDependents;
	
}

void PrintHeading(ofstream &outSalary, ofstream &outSalary2)
{
	outSalary << "Plan A          Plan B          Better Plan" << endl 
	          << "------          ------          -----------" << endl;
	
	outSalary2 << "Gross     Social      State       Federal     Health      Union    Net"<< endl
	           << " Pay     Security   Income Tax  Income Tax   Insurance     Dues    Pay"<< endl
	           << "-----    --------   ----------  ----------   ---------    -----    ---"<< endl;
	
	cout << "Gross     Social      State       Federal     Health      Union    Net"<< endl
	     << " Pay     Security   Income Tax  Income Tax   Insurance     Dues    Pay"<< endl
	     << "-----    --------   ----------  ----------   ---------    -----    ---"<< endl;
}

float CalculateGrossPayA(float totalSales, int hoursWorked)
{
	float payGross;
	
	if (hoursWorked <= 40)
		payGross = (totalSales * 0.10) + (8.25 * hoursWorked);
    else
        payGross = (totalSales * 0.10) + (8.25 * 40) + (hoursWorked - 40) * (8.25*1.50);
	
	return payGross;
}

float CalculateGrossPayB(float totalSales)
{
	float payGrossB;
	
	payGrossB = totalSales * 0.25;
	return payGrossB;
}

float CalculateSocialSecurity(float payGross)
{
	float SS;

	SS = payGross * 0.06;
	return SS;
}

float CalculateStateTax(float payGross)
{
	float StateTax;

	StateTax = payGross * 0.08;
	return StateTax;
}

float CalculateFedTax(float payGross)
{
	float FedTax;

	FedTax = payGross * 0.12;
	return FedTax;
}

float CalculateNetPay(float grossPay, float SocialSecurity, float stateIncomeTax,
					  float fedIncomeTax, int numDependents)
{
	float netPay;

	if (numDependents >= 3)
		netPay = grossPay - SocialSecurity - stateIncomeTax - fedIncomeTax - HealthInsurance 
				   - UnionDues;
	else
		netPay = grossPay - SocialSecurity - stateIncomeTax - fedIncomeTax - UnionDues;
	return netPay;
}

void PrintPayAndDeductions (ofstream &outSalary,ofstream &outSalary2, float grossPay,float 
							grossPayA,float grossPayB, float SocialSecurity,float stateIncomeTax,
							float fedIncomeTax,float netPay, int numDependents)
{
  cout << fixed
       << setprecision(2);
  
  outSalary2 << fixed
             << setprecision(2);
  
  outSalary << fixed
            << setprecision(2);

	char AorB;
	if (grossPay == grossPayA)
		AorB = 'A';
	else
		AorB = 'B';

	outSalary << grossPayA << "          " << grossPayB << "               " << AorB << endl;

	if (numDependents >= 3)
	{	
	outSalary2 << grossPay << setw(10) << SocialSecurity << setw(11) << stateIncomeTax << setw(12)			       
			   << fedIncomeTax << setw(13) << HealthInsurance << setw(10) << UnionDues << setw(10)
               << netPay << endl;
	
	cout << grossPay << setw(10) << SocialSecurity << setw(11) << stateIncomeTax << setw(12)			       
         << fedIncomeTax << setw(13) << HealthInsurance << setw(10) << UnionDues << setw(10)
         << netPay << endl;
	}
	else
	{
	outSalary2 << grossPay << setw(10)<< SocialSecurity <<setw(11)<< stateIncomeTax <<setw(12)
			   << fedIncomeTax << setw(13)<< "0.00" << setw(10) << UnionDues <<setw(10)<< netPay 
			   << endl;
	
	cout << grossPay << setw(10)<< SocialSecurity <<setw(11)<< stateIncomeTax <<setw(12)
		 << fedIncomeTax << setw(13)<< "0.00" << setw(10) << UnionDues <<setw(10)<< netPay 
		 << endl;
	}
}