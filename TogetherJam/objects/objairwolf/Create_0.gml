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
upperYLimit = 40;
lowerYLimit = 480;

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