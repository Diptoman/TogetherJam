/// @description Upgrades

if (waveType == 0)
{
	upgrade = choose(0, 1, 1);
}
else if (waveType == 1)
{
	upgrade = choose(0, 0, 1);
}
else if (waveType == 2)
{
	upgrade = choose(0, 1);
}

if (upgrade == 0)
{
	en = instance_create_layer(room_width + 64, random_range(40, 720), "Enemies", objAssBlaster);
	en.containsUpgrade = true;
}
else if (upgrade == 1)
{
	instance_create_layer(room_width + 64, random_range(720, 1080), "EnemySpawner", objHelipad);
} 

alarm[2] = min(maxTimeBetweenUpgrades, random_range(baseMinTimeBetweenUpgrades + increaseInTimeBetweenUpgradesPerDifficulty * global.waveDifficulty, baseMaxTimeBetweenUpgrades + increaseInTimeBetweenUpgradesPerDifficulty * global.waveDifficulty)) * room_speed;