event_inherited();

targetX = x - 128 + floor(random(288));
targetY = y - 160 - floor(random(160));

target = -1;

damage = 60;
spd = 16;
locked = false;

move_towards_point(targetX, targetY, spd);