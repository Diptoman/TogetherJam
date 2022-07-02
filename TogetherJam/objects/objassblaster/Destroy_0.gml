event_inherited();

if (containsUpgrade && !outOfBounds)
{
	instance_create_layer(x, y, "Upgrades", objUpgrade);
}

if (carriedCivilian != -1)
{
	with (carriedCivilian) instance_destroy();
	carriedCivilian = -1;
	objGameController.CivilianMissed();
}