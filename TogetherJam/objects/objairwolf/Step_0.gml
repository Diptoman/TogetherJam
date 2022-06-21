event_inherited();

//Test
if (keyboard_check_pressed(vk_space))
{
	attachNum += 1;
	heli = instance_create(0, 0, objHeli);
	ds_list_add(heliList, heli);
	heli.SetupPosition(self.id, attachNum);
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
}