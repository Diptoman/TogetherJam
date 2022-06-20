event_inherited();

//Movement
if (active)
{
	currentSpeedX = scr_calculate_speed_x(playerSlot, currentSpeedX, accelerationX, decelerationX, maxSpeedX) 
	var targetDestX = x + currentSpeedX / room_speed;
	if (sign(currentSpeedX) > 0 && targetDestX > upperXLimit)
	{
		x = upperXLimit;
	}
	else if (sign(currentSpeedX) < 0 && targetDestX < lowerXLimit)
	{
		x = lowerYLimit;
	}
	else
	{
		x += currentSpeedX / room_speed;
	}
	
	currentSpeedY = scr_calculate_speed_y(playerSlot, currentSpeedY, accelerationY, decelerationY, maxSpeedY);
	var targetDestY = y + currentSpeedY / room_speed;
	if (sign(currentSpeedY) < 0 && targetDestY < upperYLimit)
	{
		y = upperYLimit;
	}
	else if (sign(currentSpeedY) > 0 && targetDestY > lowerYLimit)
	{
		y = lowerYLimit;
	}
	else
	{
		y += currentSpeedY / room_speed;
	}
}