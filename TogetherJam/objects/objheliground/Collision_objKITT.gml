/// @description Insert description here
// You can write your code in this editor

heli = instance_create_layer(x, y, "Characters", objHeli);
objAirwolf.HeliSpawned(heli);
parent.sprite_index = sprHelipadUsed;
audio_play_sound(sndAirwolfPowerUp, 70, false);
instance_destroy();