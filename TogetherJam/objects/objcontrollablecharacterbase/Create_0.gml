event_inherited();

//Controllable Basic
playerSlot = 1;
active = true;

//Horizontal Movement
accelerationX = 960; //per sec
decelerationX = 1380; //per sec
maxSpeedX = 480; //per sec

//Vertical Movement
accelerationY = 720; //per sec
decelerationY = 840; //per sec
maxSpeedY = 240; //per sec

currentSpeedX = 0;
currentSpeedY = 0;

//Secondary shooting
specialUseTime = 120;
alarm[0] = specialUseTime;
canUseSpecial = false;