import contrib.math.string;
import std.stdio;

/* 
    Evaluate strings of "math" to a float result
*/
void main() {
    writefln( "2*5+1 = %f", evaluateMathString( "2*5+1" ) ); 
    writefln( "2*5/2+1 = %f", evaluateMathString( "2*5/2+1" ) ); 
    writefln( "2*(2+3)+1 = %f", evaluateMathString( "2*(2+3)+1" ) ); 
}

