event_inherited();

if ((distance_to_point(targetX, targetY) <= 0) && (type == 2))
{
	if (ds_stack_size(moveTargetX) > 0)
	{
		targetX = ds_stack_pop(moveTargetX);
		targetY = ds_stack_pop(moveTargetY);

		MoveToScaling(targetX, targetY, currentMaxSpeed, currentMaxSpeed + 2);
		currentMaxSpeed += 2;
	}
	else
	{
		outOfBounds = true;
		instance_destroy();
	}
}

if (x < -48)
{
	outOfBounds = true;
	instance_destroy();
}