event_inherited();


if ((distance_to_point(targetX, targetY) < 16) && !locked)
{
	locked = true;
	target = instance_nearest(x, y, objAssBlaster);
}
else if (target != -1)
{
	if (instance_exists(target))
	{
		direction = point_direction(x, y, target.x, target.y);
		move_towards_point(target.x, target.y, spd)
	}
}


if (!locked)
{
	spd = lerp(16, 12, distance_to_point(targetX, targetY));
}
else
{
	spd = 12;
}

image_angle = direction;