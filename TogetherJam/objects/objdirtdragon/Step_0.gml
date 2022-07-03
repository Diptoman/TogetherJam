event_inherited();

if (y > initY)
{
	doNotCount = true;
	instance_destroy();
}

if (vspeed > 12 * global.slowmotimescale * global.timescale)
{
	vspeed = 12 * global.slowmotimescale * global.timescale;
}