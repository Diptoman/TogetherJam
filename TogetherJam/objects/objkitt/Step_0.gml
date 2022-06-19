/// @description Insert description here
if (!active)
{
	exit;
}

//X Movement
if (inputdog_down("right", playerSlot))
{
	currentSpeed += acceleration / room_speed + (sign(currentSpeed) < 0 ? deceleration / room_speed : 0);
}
else if (inputdog_down("left", playerSlot))
{
	currentSpeed -= acceleration / room_speed + (sign(currentSpeed) > 0 ? deceleration / room_speed : 0);
}
else
{
	currentSpeed -= deceleration / room_speed * sign(currentSpeed);
}

if (abs(currentSpeed) > maxSpeed)
{
	currentSpeed = sign(currentSpeed) * maxSpeed;
}

x += currentSpeed / room_speed;

//Y Movement
if (inputdog_down("up", playerSlot) && y > upperYLimit)
{
	currentYSpeed = -verticalSpeed / room_speed;
}
else if (inputdog_down("down", playerSlot) && y < lowerYLimit)
{
	currentYSpeed = verticalSpeed / room_speed;
}
else
{
	currentYSpeed = 0;
}

y += currentYSpeed;