event_inherited();

if (active)
{
	Shoot(16, 0);
}

//Special
if (inputdog_pressed("special", playerSlot) && canUseSpecial && active)
{
	for(i = 0; i < 5; i++)
	{
		instance_create_layer(x, y, "Characters", objKITTMissile);
	}
	
	canUseSpecial = false;
	alarm[0] = specialUseTime;
}