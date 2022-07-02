/// @description Insert description here
// You can write your code in this editor
if(shakeDurLeft>0)
{
	if  (shakeDurLeft%shakeSlowness==0)
	{
		targetX = irandom_range(-shakeStr, shakeStr)
		targetY = irandom_range(-shakeStr, shakeStr)
		
		targetX = lerp(camera_get_view_x(view_camera[0]), targetX, shakeStiffness)
		targetY = lerp(camera_get_view_y(view_camera[0]), targetY, shakeStiffness)
		camera_set_view_pos(view_camera[0],targetX, targetY)
	
	
	}
	
	shakeDurLeft -= 1
}
else
{
	camera_set_view_pos(view_camera[0],0, 0)
	instance_destroy()
}