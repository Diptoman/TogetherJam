/// @description Insert description here
// You can write your code in this editor

if (!outOfBounds)
{
	a = instance_create_layer(x, y, "Enemies", objEnemyExplosion);
	a.size = explSize;
	if (!doNotCount)
	{
		global.creaturesKilled += 1;
	}
	else
	{
		global.creaturesMissed += 1;
	}
}
else
{
	global.creaturesMissed += 1;
}

if (canSpawnCivilians && isCivilianSpawner)
{
	if (!outOfBounds)
	{
		instance_create_layer(x, y, "Civilians", objCivilian);
	}
	else
	{
		objGameController.CivilianMissed();
	}
}