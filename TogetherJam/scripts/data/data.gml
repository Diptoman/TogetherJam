// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function UpdateDataFile(index, value)
{
	ds_list_replace(global.gamedata, index, value);
	data = file_text_open_write("GameData.tt");
	file_text_write_string(data, ds_list_write(global.gamedata));
	file_text_close(data);
}