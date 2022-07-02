/// @description Collision

if (canBeHit)
{
	global.currenthp -= other.damageFactor;
	alarm[8] = 120;
	canBeHit = false;
	damageTween = TweenFire(id, EaseInOutQuad, TWEEN_MODE_LOOP, false, 0, 20, "image_alpha", 1, 0);
}