// Decimal to Binary Data Converter

// Author: Matthew Knight
// Date: 2017-02-27

// This program takes a "csv" file with only one column of base 10 numbers and
// converts them to 2's compliment binary representation in a different file.
// The program takes 3 arguments: the input file, output file name, and the
// number of bits.

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>

using namespace std;

// Function for converting an integer into its binary representation in the form
// of a string
char *dec2bin(int val, int bits, bool twoComp);

int main(int argc, char *argv[])
{ 
    // Error if there is a wrong number of arguments
    if (argc != 7)
	cerr << "Incorrect number of arguments" << endl;

    int c;
    char *inputFile;
    char *outputFile;
    int width = 1;

     
    // Determine what the input arguments are
    while ((c = getopt(argc, argv, "f:o:b:")) != -1)
    {
	switch(c)
	{
	    case 'f':
		inputFile = optarg;
		break;
	    case 'o':
		outputFile = optarg;
		break;
	    case 'b':
		width = strtol(optarg, NULL, 10);
		break;
	}
    }
    
    // Report operations
    cout    << "Input File: " << inputFile << endl
	    << "Number of bits: " << width << endl
	    << "Output File: " << outputFile << endl;

    // Open files
    ifstream in;
    ofstream out;
    
    cout << "Opening Files" << endl;
    in.open(inputFile);
    out.open(outputFile);
    
    char* val;
    cout << "Starting Transfer" << endl;

    // Convert Values
    
    out << dec2bin() << endl;
    
    cout << "Closing Files" << endl;

    // Close files
    in.close();
    out.close();
}

// Function for converting an integer into its binary representation in the form
// of a string
char *dec2bin(int val, int bits, bool twoComp)
{
    char string[bits+1];

    if (twoComp)

    return string;
}
