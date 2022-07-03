// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DrawUIMenuText(x, y, text, font, color = c_black, alpha = 1, outlined = false, outWidth = 4, outColor = c_black)
{
	draw_set_font(font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_color(color);
	draw_set_alpha(alpha);
	
	if (outlined)
	{
		draw_text_outline(x, y, text, outWidth, outColor, 16);
	}
	else
	{
		draw_text(x, y, text);
	}
}