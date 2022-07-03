//Create groups of shriekers

instance_create_layer(x, y, "Enemies", objShrieker);
targetAmount = min(1 + floor(global.waveDifficulty / 2) + round(random(1)), 16);
targetPow = ceil(sqrt(targetAmount));

//Move the spawner away to ensure it spawns within bounds
if (y + targetPow * 64 > global.botMovementLimit - 8)
{
	y = global.botMovementLimit - 8 - targetPow * 64;
}

//Spawn
for(i = 0; i < targetAmount; i++)
{
	instance_create_layer(x + floor(i/targetPow) * 72, y + (i mod targetPow) * 64, "Enemies", objShrieker);
}

audio_play_sound(sndShrieker, 50, false);