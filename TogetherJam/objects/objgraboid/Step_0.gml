event_inherited();

hspeed = -4 * global.timescale * global.slowmotimescale;

if (x < -32)
{
	outOfBounds = true;
	instance_destroy();
}

if (!objGameController.isPlaying)
{
	image_speed = 0;
}