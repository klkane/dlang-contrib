/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

module contrib.util.timer;
import core.time;
import core.thread;
import std.stdio;
import std.datetime : Clock;
import std.algorithm;

class Timer {
    long last_check;
    long pulse_duration = 1000;
    bool persistant = false;
    bool active = false;
    void delegate() action;
 
    this( void delegate() act ) {
        action = act;
    }

    this( void delegate() act, long dur ) {
        action = act;
        pulse_duration = dur;
    }

    void start() {
        active = true;
        last_check = Clock.currStdTime / 10000;
    }

    void stop() {
        active = false;
    }

    bool check() {
        if( active ) {
            auto i = Clock.currStdTime / 10000;
            if( last_check + pulse_duration < i ) {
                if( persistant ) {
                    last_check = i;
                } else {
                    stop();
                }
                action();
                return true;
            }
        }

        return false;
    }
}

class TimerSet {
    Timer[] timers;
    long setDuration = 150;
 
    void add( Timer t ) {
        timers ~= t;
    }

    void run() {
        bool go = true;
        while( go ) {
            // assume we are done
            go = false;
            int remove_index;
            bool do_remove = false;
            foreach( int i, Timer t; timers ) {
                if( t.check() ) {
                    // a timer condition has been met
                }    
            
                if( t.active ) {
                    // something is still active lets do another loop
                    go = true;
                } else {
                    // mark this timer for removal
                    do_remove = true;
                    remove_index = i;
                }
            }

            // remove last timer that was not active.
            // should i attempt to remove all inactive timers at once
            // or a max of 1 at a time?
            if( do_remove ) {
                timers = remove( timers, remove_index );
            }

            Thread.sleep( setDuration.msecs ); 
        }
    }
}

