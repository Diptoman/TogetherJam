/// @description Insert description here
// You can write your code in this editor
isOn = false;
index = 0;

function Activate()
{
	isOn = true;
	sprite_index = spr_Skull;
	TweenFire(id, EaseInOutQuad, TWEEN_MODE_ONCE, true, 0, 0.2, "image_xscale", 1, 1.2); 
	TweenFire(id, EaseInOutQuad, TWEEN_MODE_ONCE, true, 0, 0.2, "image_yscale", 1, 1.2);
	TweenFire(id, EaseInOutQuad, TWEEN_MODE_ONCE, true, 0.2, 0.5, "image_xscale", 1.2, 1);
	TweenFire(id, EaseInOutQuad, TWEEN_MODE_ONCE, true, 0.2, 0.5, "image_yscale", 1.2, 1);
}