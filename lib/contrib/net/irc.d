/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

module contrib.net.irc;

import std.socket;
import std.string;
import std.stdio;
import std.conv;

/* 
    IrcEvent and kids all have the same constructors,
    use a template to avoid repeating the same block
    over and over again.
*/
template ircevent_constructors() {
    this() {}

    this( IrcConnection _conn, string _host ) {
        connection = _conn;
        host = _host;
    }
}

/*
    Base class for all Irc Events. Children are used
    to easily handle what type of event is being processed
*/
class IrcEvent {
    public IrcConnection connection;
    public string host;
    public string message;    
    public string _rawMessage;
    public string recipient;
    public string sender;

    mixin ircevent_constructors;
}

class PingEvent : IrcEvent {
    mixin ircevent_constructors;
}

class ConnectEvent : IrcEvent {
    mixin ircevent_constructors;
}

class DisconnectEvent : IrcEvent {
    mixin ircevent_constructors;
}

class PrivateMessageEvent : IrcEvent {
    mixin ircevent_constructors;
}

class ChannelMessageEvent : IrcEvent {
    mixin ircevent_constructors;
}

/* 
    Manage connections to the various IRC servers.
*/
class IrcConnection {
    private string _hosts[Socket];
    private bool _run = true;
    public int max_connections = 20;
    public IrcEventHandler eventHandler;

    public bool connect( string host ) {
        return connect( host, 6667 );
    }
    
    public bool connect( string host, ushort port ) {
        auto sock = new TcpSocket( new InternetAddress( host, port ) );
        auto hostKey = format( "%s:%d", host, port );
        if( sock.isAlive ) {
            _hosts[sock] = hostKey;
        }

        auto event = new ConnectEvent( this, hostKey );
        eventHandler.processEvent( event ); 
        return sock.isAlive;
    }

    public void run() {
        SocketSet set = new SocketSet( max_connections );
        while( _run && _hosts.length > 0 ) {
            set.reset();
            foreach( Socket sock, string host; _hosts ) {
                set.add( sock );
            }

            Socket.select( set, null, null );

            foreach( Socket sock, string host; _hosts ) {
                if( set.isSet( sock ) ) {
                    // TODO what happens if the buffer is > 1024?
                    char[1024] buf;
                    long size = sock.receive( buf );
                    string input = chomp( to!string( buf[0..size] ) );

                    if( size == Socket.ERROR ) {
                        writefln( "socket error on %s", host );
                    } else if ( size == 0 ) {
                        _hosts.remove( sock );
                        sock.close();
                        auto event = new DisconnectEvent( this, host );
                        eventHandler.processEvent( event );
                        writefln( "socket from %s disconnected", host );
                        break;
                    } else {
                        _process_input( host, input );
                    }
                }
            }
        }
    }

    /*
        Take the raw input from the IRC server, parse it then issue the appropriate event
    */
    public void _process_input( string host, string input ) {
        auto commands = split( input, "\n" );
        foreach( string cmd; commands ) {
            
            auto words = split( cmd );
            if( words.length > 2 && words[1] == "PRIVMSG" ) {
                auto chunks = split( words[0], "!" );
                auto sender = chompPrefix( chunks[0], ":" );

                if( words[2].indexOf( "#" ) >= 0 ) {
                    auto event = new ChannelMessageEvent( this, host );
                    event._rawMessage = cmd;
                    event.recipient = words[2];
                    event.sender = sender;
                    event.message = chompPrefix( stripLeft( cmd[cmd.indexOf( words[2] ) 
                        + words[2].length..cmd.length] ), ":" );
                    eventHandler.processEvent( event );
                } else {
                    auto event = new PrivateMessageEvent( this, host );
                    event._rawMessage = cmd;
                    event.recipient = words[2];
                    event.sender = sender;
                    event.message = chompPrefix( stripLeft( cmd[cmd.indexOf( words[2] ) 
                        + words[2].length..cmd.length] ), ":" );
                    eventHandler.processEvent( event );
                }
            } else if( words.length >= 1 && words[0] == "PING" ) {
                auto event = new PingEvent( this, host );
                event._rawMessage = cmd;
                if( words.length > 1 ) {
                    event.message = chomp( join( words[1..$], " " ) );
                } else {
                    // if words.length < 1 we can assume that we are talking to loopback?
                    event.message = "127.0.0.1";
                }
                eventHandler.processEvent( event );
            }
        }
    }                
    
    private void _send( string host, string message ) {
        foreach( Socket sock, string _host; _hosts ) {
            if( host == _host ) {
                sock.send( message ~ "\r\n" );
            }
        }
    }

    public void sendMessage( string host, string target, string message ) { 
        _send( host, "PRIVMSG " ~ target ~ " :" ~ message );; 
    }

    public void registerUser( string host, string username, string realname ) {
        registerUser( host, username, realname, 0, "*" );
    }
    
    public void registerUser( string host, string username, 
        string realname, uint mode, string unused ) {
        _send( host, "USER " ~ [username, to!string(mode), unused, ":" ~ realname].join(" ") );
    } 

    void setMode( string host, string channel, string[] modes ... ) {
        _send( host, format( "MODE %s %s", channel, modes.join( " " ) ) );    
    }

    void operator( string host, string nick, string password ) {
        _send( host, format( "OPER %s %s", nick, password ) );
    }

    void setNick( string host, string nick ) { 
        _send( host, "NICK " ~ nick );
    }

    void joinChannel( string host, string channel ) { 
        _send( host, "JOIN " ~ channel );
    }

    void pong( string host, string message ) {
        _send( host, format( "PONG %s", message ) );
    }

    public void shutdown( ) {
        _run = false;
        foreach( Socket sock, string host; _hosts ) {
            sock.close();    
        }
    }
}

interface IrcEventHandler {
    void processEvent( ConnectEvent event );
    void processEvent( DisconnectEvent event );
    void processEvent( PrivateMessageEvent event );
    void processEvent( ChannelMessageEvent event );
    
    /*
        the irc server will periodically ping the client, if there is 
        no response then the client will be disconnected by the server
        We handle this as final so any event handler doesn't need to
        think about or worry about this.
    */
    final void processEvent( PingEvent event ) {
        event.connection.pong( event.host, event.message );
    }
}
