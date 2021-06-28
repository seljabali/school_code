//File: se_fahr2cel.cpp
//Purpose: Converts a Fahrnheit temperature to its Celsius equivalent
//Author  Sami Eljabali
//Date: 8/20/2003
//Input: A temperature in Fahrnheit from the keyboard
//Output: The equivalent temperature in Celsius, to the screen
//Description:
//
//   Algorithm: Prompt for Fahrnheit temperature and read it in
//              Calculate the equivalent Celsius temperature  
//                  C= (5/9) * (f - 32)
//              Output Celsius temperature
//                     Display Celsius temperature


#include <iostream>

using namespace std;

void main()

{
  float  celsius,     //Celsius temperature reading
         fahrenheit; //Equivalent Fahernheit temperature

  //Prompt for Fahrenheit temperature and read it in
  cout << "Enter the Fahernheit temperature: ";
  cin >> fahrenheit;

  //Calucalte the equivalent Calsius temperature
  celsius = (5.0 / 9.0) * (fahrenheit - 32);

  //Output the Celsius temperature
  cout << fahrenheit << " degrees Fahrenheit = " << celsius
       << " degress Celsius" << endl;

  //Pause output window
  cin.get();
  cin.get();
}