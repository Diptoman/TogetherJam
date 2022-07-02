event_inherited();

explSize = .8;

targetX = -64;

hp = 200;

type = ceil(random_range(0, 2));

initSpeed = 5;
currentMaxSpeed = 7;
damageFactor = 15;

containsUpgrade = false;

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
		ds_stack_push(moveTargetY, random_range(global.topMovementLimit + 16, global.AirwolfBotMovementLimit - 32));
	}
	
	targetX = ds_stack_pop(moveTargetX);
	targetY = ds_stack_pop(moveTargetY);
}

MoveToScaling(targetX, targetY, initSpeed, currentMaxSpeed);
currentMaxSpeed += 1;

canSpawnCivilians = true;
isCivilianSpawner = false;
carriedCivilian = -1;

alarm[0] = 1;