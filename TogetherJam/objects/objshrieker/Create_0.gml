event_inherited();

targetX = -64;

type = 1; //ceil(random_range(0, 2));

currentMaxSpeed = 14;

if (type == 1)
{
	targetY = y;
}

MoveToScaling(targetX, targetY, 8, currentMaxSpeed);