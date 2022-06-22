event_inherited();

//Init
finalTarget = -1;
attachNumber = 0;
attachRing = 0;
spaceInCurrentRing = 1;
attachSpeed = 1;

//Shooting
bulletGapTime = 14;
bulletSpeed = 10;
bulletSprite = sprHeliBullet;
bulletDamage = 20;

//Temp
image_xscale = 0.5;
image_yscale = 0.5;

function SetupPosition(target, finalAttachNumber)
{
	//Find out ring
	spaceInRing = target.baseSpace;
	targetRing = 1;
	ringAttachNumber = 0;
	currentSpaceIncrement = target.baseSpaceIncrement;
	
	//Find out final values
	for(currentSpace = 1; currentSpace < finalAttachNumber; currentSpace++)
	{
		if (ringAttachNumber >= spaceInRing)
		{
			spaceInRing += currentSpaceIncrement;
			currentSpaceIncrement += target.spaceIncrementPerRing;
			targetRing += 1;
			ringAttachNumber = 1;
		}
		else 
		{
			ringAttachNumber += 1;
		}
	}
	
	attachNumber = ringAttachNumber;
	attachRing = targetRing;
	spaceInCurrentRing = spaceInRing;
	finalTarget = target;

	//Speed
	baseAttachSpeed = random_range(0.2, 0.35);
	attachSpeed = baseAttachSpeed / attachRing;
}