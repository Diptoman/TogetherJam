if (hp <= 0)
{
	isAlive = false;
	instance_destroy();
}

//Movement function executions
if (moveType == "Scaling")
{
	distanceScale = point_distance(x, y, finalX, finalY) / point_distance(initialX, initialY, finalX, finalY);
		
	if (distance_to_point(finalX, finalY) > finalSpeed)
	{
		move_towards_point(finalX, finalY, (initialSpeed + (finalSpeed - initialSpeed) * (1 - distanceScale)) * global.slowmotimescale * global.timescale);
	}
	else
	{
		speed = 0;
	}
}