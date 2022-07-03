event_inherited();

if (containsUpgrade && !outOfBounds)
{
	instance_create_layer(x, y, "Upgrades", objUpgrade);
}

if (carriedCivilian != -1)
{
	with (carriedCivilian) instance_destroy();
	carriedCivilian = -1;
}

if (carriedUpgrade != -1)
{
	with (carriedUpgrade) instance_destroy();
	carriedUpgrade = -1;
}