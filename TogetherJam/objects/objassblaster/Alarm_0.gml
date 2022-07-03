/// @description Insert description here
// You can write your code in this editor

if (isCivilianSpawner)
{
	type = 1;
	carriedCivilian = instance_create_depth(x, y + 30, layer_get_depth("Enemies") + 1, objCarriedCivilian);
}
else
{
	type = ceil(random_range(0.01, 2));
}

if (containsUpgrade)
{
	carriedUpgrade = instance_create_depth(x, y + 30, layer_get_depth("Enemies") + 1, objCarriedUpgrade);
}

if (type == 1)
{
	targetY = random_range(global.topMovementLimit + 16, global.AirwolfBotMovementLimit - 64);
}
else
{
	moveTargetX = ds_stack_create();
	moveTargetY = ds_stack_create();
	var totalDivs = 3;
	for(i = 0; i < totalDivs; i++)
	{
		ds_stack_push(moveTargetX, i * room_width / totalDivs - 64);
		ds_stack_push(moveTargetY, random_range(global.topMovementLimit + 16, global.AirwolfBotMovementLimit - 64));
	}
	
	targetX = ds_stack_pop(moveTargetX);
	targetY = ds_stack_pop(moveTargetY);
}

MoveToScaling(targetX, targetY, initSpeed, currentMaxSpeed);
currentMaxSpeed += .5;