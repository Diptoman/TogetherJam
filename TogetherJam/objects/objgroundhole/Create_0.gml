type = 1;

isCivilianSpawner = false;

hspeed = global.baseRoadSpeed;

//image_speed = 0.05 + random(0.1);

spawnTime = 90 + floor(random(210));
alarm[0] = spawnTime;
alarm[1] = spawnTime - 60;
alarm[2] = 1;
canSwitch = false;