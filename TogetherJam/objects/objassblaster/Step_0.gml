event_inherited();

if ((type == 2) && (distance_to_point(targetX, targetY) <= 0))
{
	if (ds_stack_size(moveTargetX) > 0)
	{
		targetX = ds_stack_pop(moveTargetX);
		targetY = ds_stack_pop(moveTargetY);

		MoveToScaling(targetX, targetY, currentMaxSpeed, currentMaxSpeed + .5);
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

//Carried civ
if (carriedCivilian != -1)
{
	carriedCivilian.x = x;
	carriedCivilian.y = y + 30;
}

//Carried civ
if (carriedUpgrade != -1)
{
	carriedUpgrade.x = x;
	carriedUpgrade.y = y + 30;
}