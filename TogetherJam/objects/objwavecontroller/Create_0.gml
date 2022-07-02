//Difficulty change
global.waveDifficulty = 0;
waveType = 0; //0 -> KITT, 1 -> Airwolf, 2 - > Mixed
baseTimeBetweenDifficulty = 20; //s
increaseInTimeBetweenDifficulty = 4; //s
alarm[0] = baseTimeBetweenDifficulty * room_speed;

//Enemies
baseMinTimeBetweenEnemies = 2;
baseMaxTimeBetweenEnemies = 3;
decreaseInTimeBetweenEnemiesPerDifficulty = 0.05;
lowestTimeBetweenEnemies = 0.5;
alarm[1] = random_range(baseMinTimeBetweenEnemies, baseMaxTimeBetweenEnemies) * room_speed;

civilianedEnemiesSpawnedLast = ds_list_create();

//Civilians
baseMinTimeBetweenCivilians = 8;
baseMaxTimeBetweenCivilians = 12;
decreaseInTimeBetweenEnemiesPerDifficulty = 0.2;
lowestTimeBetweenCivilians = 4;
timeFromLastCivilian = 0;
nextCivilianTime = random_range(baseMinTimeBetweenCivilians, baseMaxTimeBetweenCivilians) * room_speed;

//Upgrades
baseMinTimeBetweenUpgrades = 12;
baseMaxTimeBetweenUpgrades = 15;
increaseInTimeBetweenUpgradesPerDifficulty = 1;
maxTimeBetweenUpgrades = 25;
alarm[2] = random_range(baseMinTimeBetweenUpgrades, baseMaxTimeBetweenUpgrades) * room_speed;

function HandleCivilianSpawn()
{
	if (timeFromLastCivilian > nextCivilianTime)
	{
		pickedEnemy = ds_list_find_value(civilianedEnemiesSpawnedLast, floor(random(ds_list_size(civilianedEnemiesSpawnedLast))));
		pickedEnemy.canSpawnCivilians = true;
	}
	nextCivilianTime = max(lowestTimeBetweenCivilians, random_range(baseMinTimeBetweenCivilians - decreaseInTimeBetweenEnemiesPerDifficulty * global.waveDifficulty, baseMaxTimeBetweenCivilians - decreaseInTimeBetweenEnemiesPerDifficulty * global.waveDifficulty)) * room_speed;
	ds_list_clear(civilianedEnemiesSpawnedLast);
}

function PickAndSpawnEnemies(total, graboidPool, shriekerSpawnerPool, assBlasterPool, dirtDragonPool)
{
	var totalPoolList = ds_list_create();
	
	for(i = 0; i < graboidPool; i++)
	{
		ds_list_add(totalPoolList, "g");
	}
	for(i = 0; i < shriekerSpawnerPool; i++)
	{
		ds_list_add(totalPoolList, "ss");
	}
	for(i = 0; i < assBlasterPool; i++)
	{
		ds_list_add(totalPoolList, "ab");
	}
	for(i = 0; i < dirtDragonPool; i++)
	{
		ds_list_add(totalPoolList, "dd");
	}
	
	for(i = 0; i < total; i++)
	{
		pos = floor(random(ds_list_size(totalPoolList)));
		pick = ds_list_find_value(totalPoolList, pos);
		ds_list_delete(totalPoolList, pos);
		
		if (pick == "g")
		{
			en = instance_create_layer(room_width + 64, random_range(global.KITTTopMovementLimit + 8, global.botMovementLimit - 8), "EnemySpawner", objGroundHole);
			en.type = 2;
			ds_list_add(civilianedEnemiesSpawnedLast, en);
		}
		else if (pick == "ss")
		{
			en = instance_create_layer(room_width + 64, random_range(global.KITTTopMovementLimit + 8, global.botMovementLimit - 8), "Enemies", objShriekerSpawner);
			ds_list_add(civilianedEnemiesSpawnedLast, en);
		}
		else if (pick == "ab")
		{
			en = instance_create_layer(room_width + 64, random_range(global.topMovementLimit, global.AirwolfBotMovementLimit), "Enemies", objAssBlaster);
			ds_list_add(civilianedEnemiesSpawnedLast, en);
		}
		else if (pick == "dd")
		{
			en = instance_create_layer(room_width + 64, random_range(global.KITTTopMovementLimit + 8, global.botMovementLimit - 8), "EnemySpawner", objGroundHole);
			ds_list_add(civilianedEnemiesSpawnedLast, en);
			en.type = 1;
		}
	}
	
	ds_list_destroy(totalPoolList);
}