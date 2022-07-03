DrawUIMenuText(x, y - 256, "SCORE BREAKDOWN", fntMenuName, c_black, 1, true, 4, c_white);
DrawUIMenuText(x, y - 32, "Distance Travelled: " + string(global.distance) + "\nMax Power: " + string(global.maxpower) + "\nMax Number: " + string(global.maxNumber) + " x 100\nCivilians Saved: " + string(global.civiliansaved) + " x 100\nGraboid Family Killed: " + string(global.creaturesKilled) + " x 50\nCreatures Missed: -" + string(global.creaturesMissed) + " x 25", fntMenuSmall, c_black, 1);
DrawUIMenuText(x, y + 160, "TOTAL SCORE: " + string(global.score), fntMain, c_black, 1, true, 4, c_white);

if (global.score > global.highscore)
{
	global.highscore = global.score;
	UpdateDataFile(1, global.score);
	
	DrawUIMenuText(x, y + 216, "LOCAL BEST!", fntMain, c_red, 1, true, 4, c_white);
}

//High scores
DrawUIMenuText(x - 580, y - 256, "GLOBAL TOP SCORES", fntMenuSmall, c_black, 1, true, 4, c_white);
DrawUIMenuTextTop(x - 580, y - 224, LLHighscoresTopFormatted(), fntMenuSmallSuper, c_black, 1);

DrawUIMenuText(x + 580, y - 256, "CURRENT RANK", fntMenuSmall, c_black, 1, true, 4, c_white);
DrawUIMenuTextTop(x + 580, y - 224, LLHighscoresCenteredFormatted(), fntMenuSmallSuper, c_black, 1);