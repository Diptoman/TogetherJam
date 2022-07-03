/// @description Collision with controllable character
if (audio_is_playing(aud))
{
	audio_sound_gain(aud, 0, 500);
}
instance_destroy();
global.civiliansaved += 1;
instance_create_layer(x, y, "UpgradeFX", objCivilianSaved);