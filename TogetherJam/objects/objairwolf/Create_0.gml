event_inherited();

//Horizontal Movement
accelerationX = 720; //per sec
decelerationX = 840; //per sec
maxSpeedX = 360; //per sec

//Vertical Movement
accelerationY = 480; //per sec
decelerationY = 540; //per sec
maxSpeedY = 240; //per sec

//Limits
baseUpperYLimit = 40;
baseLowerYLimit = 480;
upperYLimit = baseUpperYLimit;
lowerYLimit = baseLowerYLimit;
baseUpperXLimit = room_width - 40;
baseLowerXLimit = 40;
upperXLimit = baseUpperXLimit;
lowerXLimit = baseLowerXLimit;

//Attach details
attachNum = 1;
baseSpaceIncrement = 4;
spaceIncrementPerRing = 2;
baseSpace = 4;

attachDistanceX = 32;
attachDistanceY = 32;
heliList = ds_list_create();

//Shooting
bulletGapTime = 12;
bulletSpeed = 12;
bulletSprite = sprAirwolfBullet;
bulletDamage = 20;

function UpdateScreenLimits()
{
	//Update limits
	if (ds_list_size(heliList) == 0)
	{
		upperYLimit = upperYLimit;
		lowerYLimit = lowerYLimit;
		upperXLimit = baseUpperXLimit;
		lowerXLimit = baseLowerXLimit;
	}
	else
	{
		var ring = ds_list_find_value(heliList, ds_list_size(heliList) - 1).attachRing;
		upperYLimit = baseUpperYLimit + ring * attachDistanceY;
		lowerYLimit = baseLowerYLimit - ring * attachDistanceY;
		upperXLimit = baseUpperXLimit - ring * attachDistanceX;
		lowerXLimit = baseLowerXLimit + ring * attachDistanceX;
	}
}