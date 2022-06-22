event_inherited();

targetX = -64;
targetY = random_range(40, 720);

type = 1; //random_range(1, 2);
if (type == 1)
{
	targetY = random_range(40, 720);
	MoveToScaling(targetX, targetY, 8, 14);
}
/*else
{
	moveTargets = ds_list_create();
	for(i = 0; i < 3; i++)
	{
		ds_list_add(moveTargets, random_range(40, 720));
	}
	MoveToScaling(targetX, targetY, 8, 14);
}*/