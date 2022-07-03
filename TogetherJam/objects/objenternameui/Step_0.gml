name = string_copy(keyboard_string, max(1, string_length(keyboard_string) - 15), 15);

if (inputdog_down("select", playerSlot) && name != "")
{
	alarm[0] = 5;
}