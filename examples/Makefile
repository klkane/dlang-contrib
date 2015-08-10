all: ansi_string game_dice net_irc math_string util_timer net_rest

ansi_string:
	dmd -ofansi_string ../lib/contrib/ansi/string.d ansi_string.d

game_dice:
	dmd -ofgame_dice ../lib/contrib/game/dice.d game_dice.d

net_irc:
	dmd -ofnet_irc ../lib/contrib/net/irc.d net_irc.d

net_rest:
	dmd -ofnet_rest ../lib/contrib/net/rest.d net_rest.d

math_string:
	dmd -ofmath_string ../lib/contrib/math/string.d math_string.d

util_timer:
	dmd -ofutil_timer ../lib/contrib/util/timer.d util_timer.d

clean:
	rm *.o ansi_string game_dice net_irc math_string util_timer net_rest
