/// @description  inputdog_tween(ang1,ang2);
/// @param ang1
/// @param ang2
function inputdog_tween(argument0, argument1) {
	return ((((argument0 - argument1) mod 360) + 540) mod 360) - 180;



}
