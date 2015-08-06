import contrib.ansi.string;
import std.stdio;

/* 
    Want to print ANSI color strings? contrib.ansi.string provides a
    function sansif that takes a string and a number of codes to apply
    to that string.  At the end of the string the color codes are 
    cleared out with the return to normal / default code.
*/
void main() {
    
    // print a red Hello followed by a Blue World
    writeln( sansif( "Hello", ANSI.RED ) ~ sansif( " World!", ANSI.BLUE ) );
    
    // use multiple codes at once!
    writeln( sansif( "Underline Bright Magenta", ANSI.MAGENTA, ANSI.BOLD, ANSI.UNDERLINE ) );
}

