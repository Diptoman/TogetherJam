/// @description Insert description here
// You can write your code in this editor

DrawUIMenuText(room_width / 2, room_height / 2 - 108, "LOCAL BEST: " + string(global.highscore) + "                                   GLOBAL BEST: " + string(LLHighscoresTopScoreList()[0]), fntMain, c_black, 1, true, 4, c_white);
if (step == 2)
{
	DrawUIMenuText(room_width / 2, room_height / 2 + 180, "Enter/GP (A) to proceed!", fntMenuSmall, c_black, 1, true, 2, c_white);
}
else if (step == 3)
{
	DrawUIMenuText(room_width / 2, room_height / 2 + 100, "Enter/GP (A) to begin game!", fntMenuSmall, c_black, 1, true, 2, c_white);
}

DrawUIMenuText(room_width / 2, room_height / 2 + 550, "Made for Together Jam by Diptoman Mukherjee (programming), Pranjal Bisht (Art) and Djoel Montpetit (Audio).", fntMenuSmallSuper, c_black, 1);