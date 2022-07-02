event_inherited();

//Horizontal Movement
accelerationX = 720; //per sec
decelerationX = 840; //per sec
maxSpeedX = 360; //per sec

//Vertical Movement
accelerationY = 600; //per sec
decelerationY = 750; //per sec
maxSpeedY = 300; //per sec

//Limits
baseUpperYLimit = global.topMovementLimit;
baseLowerYLimit = global.AirwolfBotMovementLimit;
upperYLimit = baseUpperYLimit;
lowerYLimit = baseLowerYLimit;
baseUpperXLimit = room_width - 64;
baseLowerXLimit = 64;
upperXLimit = baseUpperXLimit;
lowerXLimit = baseLowerXLimit;

//Attach details
attachNum = 1;
baseSpaceIncrement = 4;
spaceIncrementPerRing = 2;
baseSpace = 4;

attachDistanceX = 60;
attachDistanceY = 60;
heliList = ds_list_create();

//Shooting
bulletGapTime = 8;
bulletSpeed = 16;
bulletSprite = sprAirwolfBullet;
bulletDamage = 20;

//Special
bombGap = 16;

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