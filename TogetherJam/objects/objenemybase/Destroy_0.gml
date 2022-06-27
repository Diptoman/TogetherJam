/// @description Insert description here
// You can write your code in this editor

if (canSpawnCivilians && isCivilianSpawner)
{
	instance_create_layer(x, y, "Civilians", objCivilian);
}