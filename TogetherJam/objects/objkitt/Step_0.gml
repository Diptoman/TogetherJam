event_inherited();

if (active)
{
	bulletDamage = 32 + global.kittpower * 2;
	Shoot(32, 0, 2);
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