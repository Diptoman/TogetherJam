/// @description Insert description here
// You can write your code in this editor

if (y > room_height + 64)
{
	instance_destroy();
	objGameController.CivilianMissed();
}

gravity = 0.3 * global.slowmotimescale * global.timescale;

if (vspeed > 8 * global.slowmotimescale * global.timescale)
{
	vspeed = 8 * global.slowmotimescale * global.timescale;
}