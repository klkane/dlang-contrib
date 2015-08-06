all: ansi_string game_dice

ansi_string:
	dmd -ofansi_string ../lib/contrib/ansi/string.d ansi_string.d

game_dice:
	dmd -ofgame_dice ../lib/contrib/game/dice.d game_dice.d

clean:
	rm *.o ansi_string game_dice
