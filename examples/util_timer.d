import contrib.util.timer;
import std.stdio;

/* 
    Evaluate strings of "math" to a float result
*/
void main() {
    auto ts = new TimerSet();
    auto tim = new Timer( { writeln( "I say something every second until you CTRL-C!" ); } );
    auto tim2 = new Timer( { writeln( "I say something once after 10 seconds" ); }, 1000*10 );
    tim.persistant = true;
    tim.start();
    tim2.start();
    ts.add( tim );
    ts.add( tim2 );
    ts.run();
}

