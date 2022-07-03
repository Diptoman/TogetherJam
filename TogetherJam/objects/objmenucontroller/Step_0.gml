/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (!audio_is_playing(menu))
{
	menu = audio_play_sound(sndMenuBGM, 100, true);
}

if (inputdog_down("select", playerSlot) && step == 2)
{
	audio_stop_all();
	global.bgm = audio_play_sound(choose(sndBGM1, sndBGM2, sndBGM3), 100, false);
	room_goto(rmGame);
}

if (inputdog_down("escape", playerSlot))
{
	game_end();
}