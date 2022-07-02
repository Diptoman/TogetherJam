/// @description Draw shit

//Power
draw_sprite_ext(spr_NumbersBarA, 0, x, y + 4, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_NumbersBarB, 0, x - 383 + (global.currenthp / global.hp) * 383, y + 4, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_NumbersBarC, 0, x, y + 4, 1, 1, 0, c_white, 1);
DrawUIText(x + 280, y + 40, global.number, fntMain, c_white);

//Numbers
draw_sprite_ext(spr_PowerBarA, 0, x, y + camera_get_view_height(view_camera[0]) - 4, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_PowerBarB, 0, x - 383 + (global.currenthp / global.hp) * 383, y + camera_get_view_height(view_camera[0]) - 4, 1, 1, 0, c_white, 1);
draw_sprite_ext(spr_PowerBarC, 0, x, y + camera_get_view_height(view_camera[0]) - 4, 1, 1, 0, c_white, 1);
DrawUIText(x + 220, y + camera_get_view_height(view_camera[0]) - 32, global.power, fntMain, c_white);

//Distance
draw_sprite_ext(spr_Score, 0, x + room_width - 400, y + 4, 1, 1, 0, c_white, 1);
DrawUIText(x + room_width - 280, y + 40, global.score, fntMain, c_white);