/// @description Stop hit tween
canBeHit = true;
if (damageTween != -1)
{
	TweenFinish(damageTween, true);
	TweenDestroy(damageTween);
	image_alpha = 1;
	damageTween = -1;
}