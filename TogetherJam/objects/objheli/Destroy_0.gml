/// @description Insert description here
// You can write your code in this editor

if (instance_exists(objAirwolf))
{
	objAirwolf.HeliDestroy(index);
	a = instance_create_layer(x, y, "Characters", objExplosion);
	a.size = 0.5;
	audio_play_sound(sndHeliExplosion, 25, false);
}