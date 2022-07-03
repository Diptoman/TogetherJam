/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if ((keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) && step == 2)
{
	room_goto(rmGame);
}