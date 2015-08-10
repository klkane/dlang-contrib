import contrib.net.rest;
import std.stdio;

void main() {
    auto rc = new RestClient( "www.google.com" );
    rc.GET( "/" );
    writeln( rc.responseContent );
}

