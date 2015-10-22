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
    NOINTENSITY = 22,
    NOUNDERLINE = 24,
    NOBLINK     = 25,
    BLACK       = 30,
    RED         = 31,
    GREEN       = 32,
    YELLOW      = 33,
    BLUE        = 34,
    MAGENTA     = 35,
    CYAN        = 36,
    WHITE       = 37,
    DEFAULT     = 39,
    BG_BLACK    = 40,
    BG_RED      = 41,
    BG_GREEN    = 42,
    BG_YELLOW   = 43,
    BG_BLUE     = 44,
    BG_MAGENTA  = 45,
    BG_CYAN     = 46,
    BG_WHITE    = 47,
    BG_DEFAULT  = 49,
    FRAME       = 51,
    ENCIRCLED   = 52,
    OVERLINE    = 53,
    NOBORDER    = 54,
    NOOVERLINE  = 55
}

string sansif( string _str, int[] codes ... ) {
    return format( "%s%s%s", sansicode( codes ), _str, sansicode( ANSI.NONE ) );
}

string sansicode( int[] codes ... ) {
    char chr = '\x1b';
    string[] strs;

    foreach( int code; codes ) {
        strs ~= to!string( code );
    }

    return format( "%s[%sm", chr, join( strs, ";" ) );
}
