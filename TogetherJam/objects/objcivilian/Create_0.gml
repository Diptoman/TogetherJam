if (y > global.KITTTopMovementLimit)
{
	if (x < room_width / 4)
	{
		hspeed = 3;
	}
	else
	{
		hspeed = -2;
	}
	vspeed = -24;
}
else
{
	if (x > 3 * room_width / 4)
	{
		hspeed = -3;
	}
	else if (x < room_width / 4)
	{
		hspeed = 3;
	}
	else
	{
		hspeed = -2 + random(4);
	}
	vspeed = -12;
}

gravity = 0.3;

aud = audio_play_sound(sndCivilian, 25, false);