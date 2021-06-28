//File:         se_inchconversion.cpp
//Purpose:      It converts the number of inchs the user entered to yards and feet
//Author:       Sami Eljabali
//Date:         8/25/2003
//Input:        Number of inchs from the keybpard
//Output:       Number of inchs the user has entered and its equivalancy to yards and to feet
//Description:  
//
//        Displays purpose of the program
//        Prompt user and read in inchs
//        Converts inches to yards:
//            yards = inches / 36
//        Converts inches to feet:
//            feet = inches / 12
//        Displays inches to yards and inches to feet respectively

#include <iostream>

using namespace std;

int main()
{
    float inches,    //Inches
          yards,    //Yards  
          feet;     //Feet

    //Displays purpose of the program
    cout << "This program allows you to enter a number of inches and prints the equivalent"; << endl
    cout << "number of yards, feet and inches." << endl, endl
    
    //Prompt user and read in inchs
    cout << "Please enter the number of inches: ";
    cin >> inches;

    //Converts inchs to yards
    yards = inches / 36

    //Converts inchs to feet
    feet = inches % 12
    
    //Displays inchs to yards and inchs to feet respectively
    cout << inches << "inches is the equivalent to ",
    << yards << "yard(s),<<
    feet << " and" << inches << "inch(es)."
    
    cin.get();
    cin.get();

    return 0;
}