/// @description Insert description here
// You can write your code in this editor

if (y > room_height + 64)
{
	instance_destroy();
	objGameController.CivilianMissed();
}

if (vspeed > 0)
{
	gravity = 0.3 * global.slowmotimescale * global.timescale;
}
else
{
	gravity = 0.3;
}

if (vspeed > 8 * global.slowmotimescale * global.timescale)
{
	vspeed = 8 * global.slowmotimescale * global.timescale;
}

if (!objGameController.isPlaying)
{
	gravity = 0;
	vspeed = 0;
	hspeed = 0;
}