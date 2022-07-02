/// @description Collision

if (canBeHit)
{
	global.currenthp -= other.damageFactor;
	alarm[8] = 120;
	canBeHit = false;
	damageTween = TweenFire(id, EaseInOutQuad, TWEEN_MODE_LOOP, false, 0, 20, "image_alpha", 1, 0);
	
	if (global.currenthp > 0)
	{
		a = instance_create_layer(x, y, "Characters", objExplosion);
		a.size = 0.4;
		b = instance_create_layer(x, y, "Controllers", objScreenShake);
		b.shakeStr = 12;
	}

}