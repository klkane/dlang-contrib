/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

module contrib.game.dice;

import std.random;
import std.string;
import std.conv;
import std.array;

int rolldie( string _str ) {
    if( _str.indexOf( "+" ) >= 0 ) {
        auto pieces = split( _str, "+" );
        int result = 0;
        foreach( string chunk; pieces ) {
            result += rolldie( chunk );
        }
        return result;
    } else if( _str.indexOf( "-" ) >= 0 ) {
        auto pieces = split( _str, "-" );
        int result = rolldie( pieces[0] );
        pieces.popFront();
        foreach( string chunk; pieces ) {
            result -= rolldie( chunk );
        }
        return result;
    } else if( _str.indexOf( "d" ) >= 0 ) {
        auto pieces = split( _str, "d" );
        bool exploding = false;

        if( pieces.length > 2 ) {
            return -1;
        }

        auto count = pieces[0];
        auto die = pieces[1];

        if( die.indexOf( "!" ) >= 0 ) {
            exploding = true;
            die = chomp( die, "!" );
        }

        int _die = to!int( die );
        int _count = to!int( count );

        int result = 0;
        while( _count > 0 ) {
            _count--;
            int _res = uniform( 0, _die ) + 1;
            result += _res;

            if( exploding && _res == _die && _die > 1 ) {
                result += rolldie( format( "1d%s!", _die ) );
            }
        }
        return result;
    }

    return to!int( _str );
}

unittest {
    assert( rolldie( "1d4+1" ) > 1 );
    assert( rolldie( "6d4+2d8-1" ) >= 7 );
    assert( rolldie( "9d10" ) <= 90 );
    assert( rolldie( "1d4!" ) >= 1 );
}

