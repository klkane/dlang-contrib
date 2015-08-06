import contrib.game.dice;
import std.stdio;

/* 
    Method that provides randomization and dice rolls based on
    a dice "grammar".
*/
void main() {
    
    /* roll a 1d4 and if it results in a 4 get a bonus roll, called
       exploding dice by some */
    writeln( rolldie( "1d4!" ) );
    
    /* roll 2d8+1, results in a number 3 - 17 */
    writeln( rolldie( "2d8+1" ) );
}

