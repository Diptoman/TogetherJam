event_inherited();

//Movement
currentSpeedX = scr_calculate_speed_x(playerSlot, currentSpeedX, accelerationX, decelerationX, maxSpeedX, active) 
var targetDestX = x + currentSpeedX / room_speed;
if (sign(currentSpeedX) >= 0 && targetDestX > upperXLimit)
{
	x = upperXLimit;
}
else if (sign(currentSpeedX) <= 0 && targetDestX < lowerXLimit)
{
	x = lowerXLimit;
}
else
{
	x += (currentSpeedX / room_speed)*global.timescale;
}

currentSpeedY = scr_calculate_speed_y(playerSlot, currentSpeedY, accelerationY, decelerationY, maxSpeedY, active);
var targetDestY = y + currentSpeedY / room_speed;
if (sign(currentSpeedY) <= 0 && targetDestY < upperYLimit)
{
	y = upperYLimit;
}
else if (sign(currentSpeedY) >= 0 && targetDestY > lowerYLimit)
{
	y = lowerYLimit;
}
else
{
	y += (currentSpeedY / room_speed)*global.timescale;
}