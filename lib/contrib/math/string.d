/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

import std.stdio;
import std.conv;
import std.string;
import std.array;
import std.regex;

float evaluateString( string _math ) {
    
}

float __mathString( string _math ) {
    string []words;
    if( _math.indexOf( "(" ) >= 0 ) {
        auto r = regex( r"\([0-9.]+([+-/*%][0-9.]+)+\)" );
        if( match( _math, r ) ) {
            writeln( _math );
            string myMatch;
            foreach( c; match( _math, r ) ) {
                myMatch = c.hit;
                break;
            }
            auto chunks = split( _math, myMatch );
            myMatch = chompPrefix( chomp( myMatch, ")" ), "(" );
            return __mathString( chunks.join( to!string( __mathString( myMatch ) ) ) );
        } else {
            writeln( "didn't match!" );
            return 1;
        }
    } else if( _math.indexOf( "+" ) >= 0 ) {
        words = split( _math, "+" );
        float res = 0;
        foreach( string w; words ) {
            res += __mathString( w );
        }
        return res;
    } else if( _math.indexOf( "-" ) >= 0 ) {
        words = split( _math, "-" );
        float res = __mathString( words[0] );
        words.popFront();
        foreach( string w; words ) {
            res -= __mathString( w );
        }
        return res;
    } else if( _math.indexOf( "*" ) >= 0 ) {
        words = split( _math, "*" );
        float res = __mathString( words[0] );
        words.popFront();
        foreach( string w; words ) {
            res *= __mathString( w );
        }
        return res;
    } else if( _math.indexOf( "/" ) >= 0 ) {
        words = split( _math, "/" );
        float res = __mathString( words[0] );
        words.popFront();
        foreach( string w; words ) {
            res /= __mathString( w );
        }
        return res;
    } else if( _math.indexOf( "%" ) >= 0 ) {
        words = split( _math, "%" );
        float res = __mathString( words[0] );
        words.popFront();
        foreach( string w; words ) {
            res %= __mathString( w );
        }
        return res;
    } else if( match( _math, r"^[0-9.]+$" ) ) {
        return to!float( _math );
    }

    return 1;
}

