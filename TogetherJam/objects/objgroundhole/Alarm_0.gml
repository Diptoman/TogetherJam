if (type == 1)
{
	instance_create_layer(x, y, "Enemies", objDirtDragon);
	sprite_index = sprDirtDragonHole;
}
else if (type == 2)
{
	a = instance_create_layer(x, y, "Enemies", objGraboid);
	a.isCivilianSpawner = isCivilianSpawner;
	instance_destroy();
}