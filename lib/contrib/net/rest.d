/*
Copyright (c) 2015 Kevin L. Kane

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE 
*/

module contrib.net.rest;

import std.string, std.conv, std.stream, std.stdio;
import std.socket, std.socketstream;


class RestClient {
    string host;
    ushort port = 80;
    string[string] headers;

    string responseContent;
    string responseCode;
    string[string] responseHeaders;

    this( string _host, ushort _port = 80 ) {
        host = _host;
        port = _port;
    }

    void addHeader( string head, string value ) {
        headers[head] = value;
    }

    void GET( string uri ) {
        _request( "GET", uri );
    }

    void _request( string method, string uri ) {
        auto sock = new TcpSocket( new InternetAddress( host, port ) );
        sock.send( format( "%s %s HTTP/1.1\r\nHost: %s\r\n\r\n", method, uri, host ) );

        string result;
        char[1024] buf;
        long size = 1024;
        while( size >= 1024 ) {
            size = sock.receive( buf );
            result ~= chomp( to!string( buf[0..size] ) ); 
            // TODO provide way to write to FileHandle here so we dont just slurp this
            // all into memory
        }

        // TODO skip this if we are writing directly to filehandle
        auto lines = splitLines( result );
        int firstEmptyLine = 100;
        foreach( int i, string l; lines ) {
            if( l == "" && i < firstEmptyLine ) {
                firstEmptyLine = i;
            }
        }
        responseContent = join( lines[firstEmptyLine+1..lines.length], "\r\n" );
        // TODO parse headers and set responseCode
    }
}
