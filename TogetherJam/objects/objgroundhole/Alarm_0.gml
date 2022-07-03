if (objGameController.isPlaying)
{
	if (type == 1)
	{
		instance_create_layer(x, y, "Enemies", objDirtDragon);
		sprite_index = sprDirtDragonHole;
		Fade();
	}
	else if (type == 2)
	{
		a = instance_create_layer(x, y, "Enemies", objGraboid);
		a.isCivilianSpawner = isCivilianSpawner;
		a.parentHole = id;
		sprite_index = sprDirtDragonHole;
	}
}