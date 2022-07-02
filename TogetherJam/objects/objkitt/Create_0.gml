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
upperYLimit = global.KITTTopMovementLimit + 16;
lowerYLimit = global.botMovementLimit - 24;
upperXLimit = 1880;
lowerXLimit = 40;

//Shooting
bulletGapTime = 10;
bulletSpeed = 14;
bulletSprite = sprKITTBullet;
bulletDamage = 32;