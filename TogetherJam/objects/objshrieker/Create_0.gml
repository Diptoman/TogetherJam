event_inherited();

explSize = 0.4;

targetX = -64;

type = 1; //ceil(random_range(0, 2));

currentMaxSpeed = 14;

if (type == 1)
{
	targetY = y;
}

damageFactor = 10;

MoveToScaling(targetX, targetY, 8, currentMaxSpeed);