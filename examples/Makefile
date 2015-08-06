all: ansi_string game_dice net_irc

ansi_string:
	dmd -ofansi_string ../lib/contrib/ansi/string.d ansi_string.d

game_dice:
	dmd -ofgame_dice ../lib/contrib/game/dice.d game_dice.d

net_irc:
	dmd -ofnet_irc ../lib/contrib/net/irc.d net_irc.d

clean:
	rm *.o ansi_string game_dice net_irc
