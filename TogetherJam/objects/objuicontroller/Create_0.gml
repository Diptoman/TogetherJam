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