event_inherited();

//Test
if (keyboard_check_pressed(vk_space))
{
	attachNum += 1;
	heli = instance_create_layer(0, 0, "Characters", objHeli);
	ds_list_add(heliList, heli);
	heli.SetupPosition(self.id, attachNum);
	
	UpdateScreenLimits();
}

if (keyboard_check_pressed(ord("X")))
{
	numToDestroy = random(ds_list_size(heliList) - 1);
	attachNum -= 1;
	with (ds_list_find_value(heliList, numToDestroy)) instance_destroy();
	ds_list_delete(heliList, numToDestroy);
	for(i = numToDestroy; i < ds_list_size(heliList); i++)
	{
		heli = ds_list_find_value(heliList, i);
		heli.SetupPosition(self.id, i + 1);
	}
	
	UpdateScreenLimits();
}

//Shoot
if (active)
{
	Shoot(16, 0);
}

//Special
if (inputdog_pressed("special", playerSlot) && canUseSpecial && active)
{
	instance_create_layer(x, y, "Characters", objAirwolfBomb);
	specialCount = 1;
	alarm[1] = bombGap;
	
	canUseSpecial = false;
	alarm[0] = specialUseTime;
}