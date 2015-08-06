import contrib.net.irc;
import std.stdio;

/* 
    Write your own IRC/Bot/Client
*/
void main() {
    auto irc = new IrcConnection();
    auto handler = new ExampleHandler();
    irc.eventHandler = handler;

    if( irc.connect( "irc.hostname.tld", 6667 ) ) { 
        writeln( "connected!" );
        irc.run();
    } else {
        writeln( "not connected!" );
    }   
}

/*
    Define a handler that implements the IrcEventHandler interface
*/
class ExampleHandler : IrcEventHandler {
    /*
        On connect register user, set nickname and join the appropriate channel
    */
    void processEvent( ConnectEvent event ) {
        event.connection.registerUser( event.host, "example", "example(robot)" );
        event.connection.setNick( event.host, "example" );
        event.connection.joinChannel( event.host, "#channel" );
    }

    /*
        On disconnect, do something?
    */
    void processEvent( DisconnectEvent event ) {
    }

    /*
        This message was sent to me privately, rather than in the channel
    */
    void processEvent( PrivateMessageEvent event ) {
        writefln( "%s: %s", event.recipient, event.message );
    }

    /*
        Channel message events
    */
    void processEvent( ChannelMessageEvent event ) {
        writefln( "%s: %s", event.recipient, event.message );
    }

}

