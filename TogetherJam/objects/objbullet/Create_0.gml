damage = 0;
function InitializeBullet(dir, spd, spr, dmg = 10, spread = 0)
{
	direction = dir - spread + floor(random(2 * spread + 1));
	speed = spd;
	sprite_index = spr;
	damage = dmg;
}