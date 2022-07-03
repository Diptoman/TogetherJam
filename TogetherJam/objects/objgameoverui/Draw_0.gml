DrawUIMenuText(x, y - 296, "GAME OVER, " + global.playerName + "!", fntMenuName, c_black, 1, true, 4, c_white);

if (global.civilianmissed >= 5)
{
	deathText = "Too many civilians died!"
}
else
{
	deathText = "You've run out of shared health!"
}

DrawUIMenuText(x, y - 240, deathText, fntMenuSmallSuper, c_black, 1, true, 4, c_white);

DrawUIMenuText(x, y, "Distance Travelled: " + string(global.distance) 
+ "\nMax Power: " + string(global.maxpower) 
+ "\nMax Number: " + string(global.maxNumber) 
+ " x 100\nCivilians Saved: " + string(global.civiliansaved) 
+ " x 100\nGraboids Killed: " + string(global.graboidsKilled) 
+ " x 100\nAss Blasters Killed: " + string(global.assBlastersKilled) 
+ " x 75\nDirt Dragons Killed: " + string(global.dirtdragonsKilled) 
+ " x 30\nShriekers Killed: " + string(global.shriekersKilled) 
+ " x 25\nCreatures Missed: -" + string(global.creaturesMissed) 
+ " x 50", fntMenuSmall, c_black, 1);
DrawUIMenuText(x, y + 248, "TOTAL SCORE: " + string(global.score), fntMain, c_black, 1, true, 4, c_white);

if (global.score >= global.highscore)
{
	global.highscore = global.score;
	UpdateDataFile(1, global.score);
	
	DrawUIMenuText(x, y + 294, "LOCAL BEST!", fntMain, c_red, 1, true, 4, c_white);
}

DrawUIMenuText(x, y + 500, "Enter/GP (A) to re-play.#Escape./GP <Back> to go back to menu", fntMenuSmallSuper, c_black, 1, true, 2, c_white);

//High scores
DrawUIMenuText(x - 580, y - 192, "GLOBAL TOP SCORES", fntMenuSmall, c_black, 1, true, 4, c_white);
DrawUIMenuTextTop(x - 580, y - 160, LLHighscoresTopFormatted(), fntMenuSmallSuper, c_black, 1);

DrawUIMenuText(x + 580, y - 192, "CURRENT RANK", fntMenuSmall, c_black, 1, true, 4, c_white);
DrawUIMenuTextTop(x + 580, y - 160, LLHighscoresCenteredFormatted(), fntMenuSmallSuper, c_black, 1);