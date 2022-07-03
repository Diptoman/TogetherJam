/// @description inputs
inputdog_add_input("left",   vk_left,    inputdog_gp_left_stick_left);
inputdog_add_input("right",  vk_right,   inputdog_gp_left_stick_right);
inputdog_add_input("up",     vk_up,      inputdog_gp_left_stick_up);
inputdog_add_input("down",   vk_down,    inputdog_gp_left_stick_down);
inputdog_add_input("switch",   ord("Z"),   gp_face3);
inputdog_add_input("slowmo",  vk_space,   gp_shoulderrb);

inputdog_add_input("left2",   ord("A"),    inputdog_gp_right_stick_left);
inputdog_add_input("right2",  ord("D"),   inputdog_gp_right_stick_right);
inputdog_add_input("up2",     ord("W"),      inputdog_gp_right_stick_up);
inputdog_add_input("down2",   ord("S"),    inputdog_gp_right_stick_down);
inputdog_add_input("switch2",   ord("J"),   gp_face2);
inputdog_add_input("slowmo2",  vk_shift,   gp_shoulderlb);

inputdog_add_input("escape", vk_escape, gp_select);
inputdog_add_input("select", vk_enter, gp_face1);