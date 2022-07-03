if (y < target)
{
	gravity = 0.25 * global.slowmotimescale * global.timescale;
	image_angle += 1;
}
else
{
	vspeed = 0;
	gravity = 0;
	hspeed = -4 * global.slowmotimescale * global.timescale;
}

if (x < -48)
{
	instance_destroy();
}