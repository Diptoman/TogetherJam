event_inherited();

if ((distance_to_point(targetX, targetY) <= 14) && (type == 2))
{
	if (ds_stack_size(moveTargetX) > 0)
	{
		targetX = ds_stack_pop(moveTargetX);
		targetY = ds_stack_pop(moveTargetY);

		MoveToScaling(targetX, targetY, 8, 14);
	}
	else
	{
		instance_destroy();
	}
}

if (x < 0)
{
	instance_destroy();
}