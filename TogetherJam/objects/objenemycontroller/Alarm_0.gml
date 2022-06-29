/// @description Insert description here
// You can write your code in this editor

instance_create_layer(room_width + 64, random_range(720, 1080), "EnemySpawner", objHelipad);
alarm[0] = timeBetweenUpgrades;