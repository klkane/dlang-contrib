/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

module contrib.ansi.string;
import std.conv;
import std.string;
import std.stdio;

enum ANSI {
    NONE        = 0,
    BOLD        = 1,
    UNDERLINE   = 4,
    BLINK       = 5,
    INVERSE     = 7,
    FONT        = 10,
    COLOR       = 30,
    BGCOLOR     = 40,
    BLACK       = 0,
    RED         = 1,
    GREEN       = 2,
    YELLOW      = 3,
    BLUE        = 4,
    MAGENTA     = 5,
    CYAN        = 6,
    WHITE       = 7,
    DEFAULT     = 9,
    NOINTENSITY = 22,
    NOUNDERLINE = 24,
    NOBLINK     = 25,
    FRAME       = 51,
    ENCIRCLED   = 52,
    OVERLINE    = 53,
    NOBORDER    = 54,
    NOOVERLINE  = 55
}

string sansif( string _str, int[] codes ... ) {
    char chr = '\x1b';
    
    string[] strs;

    foreach( int code; codes ) {
        strs ~= to!string( code );       
    }

    return format( "%s[%sm%s%s[0m", chr, join( strs , ";" ), _str, chr );
}

