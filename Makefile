all: library

library:
	dmd -lib -ofdlangcontrib lib/contrib/net/irc.d lib/contrib/ansi/string.d

clean:
	rm *.a
