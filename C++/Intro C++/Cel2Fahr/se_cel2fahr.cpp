//File: se_cel2fahr.cpp
//Purpose: Converts a Celsius temperature to its Fahrenheit equivalent
//Author  Sami Eljabali
//Date: 8/20/2003
//Input: A temperature in Celsius from the keyboard
//Output: The equivalent temperature in Fahrenheit, to the screen
//Description:
//
//   Algorithm: Prompt for Celsius temperature and read it in
//              Calculate the equivalent Fahrenheit temperature  
//                  F= 9/5 * C + 32
//              Output Fahrnheit temperature
//                     Display Farenheit temperature


#include <iostream>

using namespace std;

void main()

{
  float  celsius,     //Celsius temperature reading
         fahrenheit; //Equivalent Fahernheit temperature

  //Prompt for Celsius temperature and read it in
  cout << "Enter the Celsius temperature: ";
  cin >> celsius;

  //Calucalte the equivalent Fahrenheit temperature
  fahrenheit = 9.0 / 5.0 * celsius + 32;

  //Output the Fahrenheit temperature
  cout << celsius << " degrees Celsius = " << fahrenheit
       << " degress Fahrenheit" << endl;

  //Pause output window
  cin.get();
  cin.get();
}