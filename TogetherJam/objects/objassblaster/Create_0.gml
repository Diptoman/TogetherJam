event_inherited();

targetX = -64;

type = ceil(random_range(0, 2));

currentMaxSpeed = 10;

if (type == 1)
{
	targetY = random_range(40, 720);
}
else
{
	moveTargetX = ds_stack_create();
	moveTargetY = ds_stack_create();
	var totalDivs = 3;
	for(i = 0; i < totalDivs; i++)
	{
		ds_stack_push(moveTargetX, i * room_width / totalDivs - 64);
		ds_stack_push(moveTargetY, random_range(40, 720));
	}
	
	targetX = ds_stack_pop(moveTargetX);
	targetY = ds_stack_pop(moveTargetY);
}

MoveToScaling(targetX, targetY, 8, currentMaxSpeed);
currentMaxSpeed += 2;