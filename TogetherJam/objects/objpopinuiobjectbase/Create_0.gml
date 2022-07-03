/// @description Insert description here
// You can write your code in this editor

targetX = 0;
targetY = 0;
initX = x;
initY = y;

function InitializeMoveUI(pointX, pointY)
{
	targetX = pointX;
	targetY = pointY;
	initX = x;
	initY = y;
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, true, 0, 0.5, "x", x, targetX);
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, true, 0, 0.5, "y", y, targetY - 64);
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, true, 0.5, 0.25, "y", targetY - 64, targetY);
}

function EndMoveUI()
{
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, true, 0, 0.25, "x", x, x - 64);
	TweenFire(id, EaseOutQuad, TWEEN_MODE_ONCE, true, 0.25, 0.5, "x", x - 64, room_width + 720);
}