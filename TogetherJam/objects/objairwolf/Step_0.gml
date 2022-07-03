event_inherited();

//Test
/*if (keyboard_check_pressed(vk_space))
{
	heli = instance_create_layer(0, 0, "Characters", objHeli);
	HeliSpawned(heli);
}*/

//Heli spawn
function HeliSpawned(heli)
{
	global.number += 1;
	attachNum += 1;
	ds_list_add(heliList, heli);
	heli.SetupPosition(self.id, attachNum);
	
	UpdateScreenLimits();
}

function HeliDestroy(index)
{
	attachNum -= 1;
	global.number -= 1;
	indexToDestroy = index;
	//show_message(" TO DEST IND " + string(indexToDestroy));
	ds_list_delete(heliList, indexToDestroy);
	for(i = indexToDestroy; i < ds_list_size(heliList); i++)
	{
		heli = ds_list_find_value(heliList, i);
		heli.SetupPosition(self.id, i + 2);
	}
	
	UpdateScreenLimits();
}

/*if (keyboard_check_pressed(ord("X")))
{
	numToDestroy = floor(random(ds_list_size(heliList)));
	with (ds_list_find_value(heliList, numToDestroy)) instance_destroy();
}*/

//Shoot
if (active)
{
	Shoot(24, 18);
}