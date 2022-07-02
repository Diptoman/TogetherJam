/// @description Insert description here
// You can write your code in this editor

function DrawUIText(x, y, text, font, color = c_black, alpha = 1)
{
	draw_set_font(font);
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);
	draw_set_color(color);
	draw_set_alpha(alpha);
	
	draw_text(x, y, text);
}

instance_create_layer(x + 400, y + 4, "Controllers", objSlowMoUI);

lifeUIList = ds_list_create();
for(i = 0; i < global.maxciviliansMissed; i++)
{
	sk = instance_create_layer(360 + i * 64, camera_get_view_height(view_camera[0]) - 32,"Controllers", objSkullUI);
	sk.index = i;
	ds_list_add(lifeUIList, sk);
}

function UpdateDeathUI(index)
{
	sk = ds_list_find_value(lifeUIList, index);
	sk.Activate();
}