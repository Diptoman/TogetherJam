/// @function scr_calculate_speed_x(playerSlot, accelerationX, decelerationX, maxSpeedX, upperXLimit, lowerXlimit, accelerationY, decelerationY, maxSpeedY, upperYLimit, lowerYLimit)
/// @param playerslot
/// @param Xaccel
/// @param Xdecel
/// @param Xmaxspd

function scr_calculate_speed_x(playerSlot, currentSpeedX, accelerationX, decelerationX, maxSpeedX, isActive)
{
	if (inputdog_down("right", playerSlot) && isActive)
	{
		currentSpeedX += accelerationX / room_speed + (sign(currentSpeedX) < 0 ? decelerationX / room_speed : 0);
	}
	else if (inputdog_down("left", playerSlot) && isActive)
	{
		currentSpeedX -= accelerationX / room_speed + (sign(currentSpeedX) > 0 ? decelerationX / room_speed : 0);
	}
	else if (abs(currentSpeedX) > decelerationX / room_speed)
	{
		currentSpeedX -= decelerationX / room_speed * sign(currentSpeedX);
	}
	else
	{
		currentSpeedX = 0;
	}
	
	if (abs(currentSpeedX) > maxSpeedX)
	{
		currentSpeedX = sign(currentSpeedX) * maxSpeedX;
	}
	
	return currentSpeedX;
}


/// @function scr_calculate_speed_y(playerSlot, accelerationY, decelerationY, maxSpeedY, upperYLimit, lowerYLimit, isActive)
/// @param playerslot
/// @param Yaccel
/// @param Ydecel
/// @param Ymaxspd

function scr_calculate_speed_y(playerSlot, currentSpeedY, accelerationY, decelerationY, maxSpeedY, isActive)
{
	if (inputdog_down("up", playerSlot) && isActive)
	{
		currentSpeedY -= accelerationY / room_speed + (sign(currentSpeedY) > 0 ? decelerationY / room_speed : 0);
	}
	else if (inputdog_down("down", playerSlot) && isActive)
	{
		currentSpeedY += accelerationY / room_speed + (sign(currentSpeedY) < 0 ? decelerationY / room_speed : 0);
	}
	else if (abs(currentSpeedY) > decelerationY / room_speed)
	{
		currentSpeedY -= decelerationY / room_speed * sign(currentSpeedY);
	}
	else
	{
		currentSpeedY = 0;
	}

	if (abs(currentSpeedY) > maxSpeedY)
	{
		currentSpeedY = sign(currentSpeedY) * maxSpeedY;
	}
	
	return currentSpeedY;
}