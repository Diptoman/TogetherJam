/// @description Init stuff

event_inherited();

//Horizontal Movement
accelerationX = 960; //per sec
decelerationX = 1380; //per sec
maxSpeedX = 480; //per sec

//Vertical Movement
accelerationY = 720; //per sec
decelerationY = 840; //per sec
maxSpeedY = 240; //per sec

//Limits
upperYLimit = 720;
lowerYLimit = 1040;

//Shooting
bulletGapTime = 8;
bulletSpeed = 16;
bulletSprite = sprKITTBullet;