timeBetweenEnemies -= 1;
increaseInWaveDiff -= 1;

//Test
if (timeBetweenEnemies <= 0)
{
	timeBetweenEnemies = 120;
	instance_create_layer(room_width + 64, random_range(40, 720), "Enemies", objAssBlaster);
	instance_create_layer(room_width + 64, random_range(720, 1080), "Enemies", objShriekerSpawner);
	var gh = instance_create_layer(room_width + 64, random_range(720, 1080), "EnemySpawner", objGroundHole);
	gh.type = 1;
	gh = instance_create_layer(room_width + 128, random_range(720, 1080), "EnemySpawner", objGroundHole);
	gh.type = 2;
}

if (increaseInWaveDiff <= 0)
{
	increaseInWaveDiff = 30 * 60;
	global.waveDifficulty += 1;
}