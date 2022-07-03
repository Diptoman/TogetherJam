/// @description Insert description here
// You can write your code in this editor

global.power += 100;
instance_destroy();
instance_create_layer(x, y, "UpgradeFX", objUpgradeFound);
audio_play_sound(sndKITTPowerUp, 70, false);