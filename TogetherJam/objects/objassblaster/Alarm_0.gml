/// @description Insert description here
// You can write your code in this editor

if (isCivilianSpawner)
{
	carriedCivilian = instance_create_depth(x, y + 30, layer_get_depth("Enemies") + 1, objCarriedCivilian);
}