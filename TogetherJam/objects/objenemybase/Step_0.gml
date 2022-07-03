if (hp <= 0)
{
	isAlive = false;
	instance_destroy();
}

//Movement function executions
if (moveType == "Scaling")
{
	distanceScale = point_distance(x, y, finalX, finalY) / point_distance(initialX, initialY, finalX, finalY);
		
	if (distance_to_point(finalX, finalY) > 1)
	{
		move_towards_point(finalX, finalY, (initialSpeed + (finalSpeed - initialSpeed) * (1 - distanceScale)) * global.slowmotimescale * global.timescale);
	}
}
else if (moveType == "Jumping")
{
	if (vspeed > 0)
	{
		gravity = targetGravity * (global.slowmotimescale * global.timescale);
	}
	else
	{
		gravity = targetGravity;
	}
	
	if (!objGameController.isPlaying)
	{
		gravity = 0;
		vspeed = 0;
		hspeed = 0;
	}
}