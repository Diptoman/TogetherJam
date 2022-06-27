/// @description Insert description here
// You can write your code in this editor

if (y > room_height + 64)
{
	instance_destroy();
	global.civilianmissed += 1;
}

gravity = 0.3 * global.slowmotimescale * global.timescale;