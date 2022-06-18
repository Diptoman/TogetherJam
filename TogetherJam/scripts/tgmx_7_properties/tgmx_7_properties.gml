// Feather disable all
var _; // USED TO HIDE SYNTAX WARNINGS

//============================
// PROPERTY SETTER FUNCTIONS
//============================

/// @function TPFunc(target, name, setter, [getter])
function TPFunc(_target, _name, _setter)
{
	static STR_DOLLAR = "$";
	static STR_AMPERSAND = "&";
	static _assignName = "";
	_setter = method(undefined, _setter);
	
	// Check for "<" or ">" to/from and strip it for _variable name assignment
	if (string_byte_at(_name, string_length(_name)) == 60 || string_byte_at(_name, string_length(_name)) == 62)
	{
		_assignName = string_delete(_name, string_length(_name), 1);
	}
	else
	{
		_assignName = _name;
	}
	
	// Connect setter method
	_target[$ STR_DOLLAR+_assignName] = _setter;
	
	// Connect getter method
	if (argument_count == 4 && argument[3] != undefined)
	{
		_target[$ STR_AMPERSAND+_assignName] = method(undefined, argument[3]);
	}
	
	return _name; // This allows us to place this directly into a tween function if desired
}_=TPFunc;


/// @function TPFuncShared(name, setter, getter)
function TPFuncShared(_name, _setter, _getter=undefined) 
{
	// Make sure system is already initialized
	static _ = TGMX_Begin();

	// Associate shared _variable name with a setter function for all targets
	global.TGMX.PropertySetters[? _name] = method(undefined, _setter);

	if (_getter != undefined)
	{
		global.TGMX.PropertyGetters[? _name] = method(undefined, argument[2]);
	}
}


/// @function TPFuncSharedNormal(name, setter, [getter])
function TPFuncSharedNormal(_name, _setter) 
{
	/*
		Normalized property scripts receive an eased _value between 0 and 1
		with additional _data passed for the start/dest values.
	*/
	
	if (argument_count == 2)
	{
		TPFuncShared(_name, _setter);	
	}
	else
	{
		TPFuncShared(_name, _setter, argument[2]);	
	}

	// Mark as a shared normalized property
	global.TGMX.PropertyNormals[? _name] = 1;
}


//============================
// Property Modifiers
//============================
/// @function TPCeil(property)
function TPCeil(_property) { return [TPCeil, _property, undefined]; }
/// @function TPFloor(property)
function TPFloor(_property) { return [TPFloor, _property, undefined]; }
/// @function TPRound(property)
function TPRound(_property) { return [TPRound, _property, undefined]; }
/// @function TPShake(property, amount)
function TPShake(_property, _amount) { return [TPShake, _property, _amount, undefined]; }
/// @function TPSnap(property, snap)
function TPSnap(_property, _snap) { return [TPSnap, _property, _snap, undefined]; }

//============================
// Data Structure Properties
//============================
/// @function TPArray(array, index);
function TPArray(_array, _index) { return [TPArray, _array, _index]; }
/// @function TPGrid(grid, x, y)
function TPGrid(_grid, _x, _y)	{ return [TPGrid, _grid, _x, _y]; }
/// @function TPList(list, index)
function TPList(_list, _index) { return [TPList, _list, _index]; }
/// @function TPMap(map, key)
function TPMap(_map, _key) { return [TPMap, _map, _key]; }

//============================
// Special Properties
//============================
/// @function TPTarget(target, name)
function TPTarget(_target, _name) { return [TPTarget, is_real(_target) ? _target : weak_ref_create(_target), _name]; }
/// @function TPCol(property)
function TPCol(_property) { return [TPCol, _property,undefined,undefined,undefined]; }
/// @function TPPath(path, absolute?)
function TPPath(_path, _absolute) { return [TPPath, _path, _absolute]; }
/// @function TPPathExt(path, x, y)
function TPPathExt(_path, _x, _y) { return [TPPath, _path, _x, _y]; } _=TPPathExt;
/// @function TPUser(user_event)
function TPUser(_user_event)		
{ 
	if (argument_count == 1) { return [TPUser, _user_event, undefined]; }
	if (argument_count == 2) { return [TPUser, _user_event, argument[1]]; }
	
	var i = -1, _args = array_create(argument_count-1);
	repeat(argument_count-1) 
	{ 
		++i;
		_args[i] = argument[i+1];
	}
	
	return [TPUser, _user_event, _args];
}

/// @ignore
function TGMX_7_Properties()
{
	// MAKE SURE THIS ONLY FIRES ONCE
	static __initialized = false;
	if (__initialized) { return 0; }
	__initialized = true;
	
	// DEFAULT INSTANCE PROPERTIES
	TPFuncShared("undefined",			function(){}, function(){return 0;});
	TPFuncShared("x",					function(_v,_t){_t.x=_v;}, function(_t){return _t.x;});
	TPFuncShared("y",					function(_v,_t){_t.y=_v;}, function(_t){return _t.y;});
	TPFuncShared("z",					function(_v,_t){_t.z=_v;}, function(_t){return _t.z;});
	TPFuncShared("direction",			function(_v,_t){_t.direction=_v;}, function(_t){return _t.direction;});
	TPFuncShared("speed",				function(_v,_t){_t.speed=_v;}, function(_t){return _t.speed;});
	TPFuncShared("hspeed",				function(_v,_t){_t.hspeed=_v;}, function(_t){return _t.hspeed;});
	TPFuncShared("vspeed",				function(_v,_t){_t.vspeed=_v;}, function(_t){return _t.vspeed;});
	TPFuncShared("image_angle",			function(_v,_t){_t.image_angle=_v;}, function(_t){return _t.image_angle;});
	TPFuncShared("image_alpha",			function(_v,_t){_t.image_alpha=_v;}, function(_t){return _t.image_alpha;});
	TPFuncShared("image_speed",			function(_v,_t){_t.image_speed=_v;}, function(_t){return _t.image_speed;});
	TPFuncShared("image_index",			function(_v,_t){_t.image_index=_v;}, function(_t){return _t.image_index;});
	TPFuncShared("image_xscale",		function(_v,_t){_t.image_xscale=_v;}, function(_t){return _t.image_xscale;});
	TPFuncShared("image_yscale",		function(_v,_t){_t.image_yscale=_v;}, function(_t){return _t.image_yscale;});
	TPFuncShared("image_scale",			function(_v,_t){_t.image_xscale=_v; _t.image_yscale=_v;}, function(_t){return _t.image_xscale;});
	TPFuncSharedNormal("image_blend",	function(_v,_t,_d){_t.image_blend=merge_colour(_d[0],_d[1],_v);}, function(_t){return _t.image_blend;});
	TPFuncShared("path_position",		function(_v,_t){_t.path_position=_v;}, function(_t){return _t.path_position;});
	TPFuncShared("path_scale",			function(_v,_t){_t.path_scale=_v;},	function(_t){return _t.path_scale;});
	TPFuncShared("path_speed",			function(_v,_t){_t.path_speed=_v;},	function(_t){return _t.path_speed;});
	TPFuncShared("path_orientation",	function(_v,_t){_t.path_orientation=_v;}, function(_t){return _t.path_orientation;});
	TPFuncShared("depth",				function(_v,_t){_t.depth=_v;}, function(_t){return _t.depth;});
	TPFuncShared("friction",			function(_v,_t){_t.friction=_v;}, function(_t){return _t.friction;});
	TPFuncShared("gravity",				function(_v,_t){_t.gravity=_v;}, function(_t){return _t.gravity;});
	TPFuncShared("gravity_direction",	function(_v,_t){_t.gravity_direction=_v;},function(_t){return _t.gravity_direction;});

	// Handle Built-in global variables as GameMaker doesn't seem to be recognising them as global values :(
	// Need this for the "Getters" to work right
	TPFuncShared("mouse_x", function(){},function(){return mouse_x;});
	TPFuncShared("mouse_y", function(){},function(){return mouse_y;});
	TPFuncShared("room_width", function(_v){room_width=_v;}, function(){return room_width;});
	TPFuncShared("room_height", function(_v){room_height=_v;}, function(){return room_height;});
	// Legacy Support
	TPFuncShared("health!", function(_v){health=_v;}, function(){return health;});
	TPFuncShared("score!", function(_v){score=_v;}, function(){return score;});
	

	#region PROPERTY MODIFIERS
	
	TPFuncShared(TPCeil, function(_value, _target, _data, _tween)
	{	/*
			Example:
				TweenFire("$", 60, TPCeil("x"), x, mouse_x)
		*/
		if (is_undefined(_data[1]))
		{
			var _prop = _data[0];
			if (is_array(_prop)) // ?
			{
				_prop[@ 1] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 1] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 1] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 1] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 1] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 1] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
			
		switch(_data[1])
		{
		case 1:
			var _array = _data[0];
			var _pass_data;
			var _length = array_length(_array)-1;
	
			if (_length == 1)
			{	
				_pass_data = _array[1];
			}
			else
			{
				_pass_data = array_create(_length);
				array_copy(_pass_data, 0, _array, 1, _length);
			}
	
			var _script = _array[0];
			_script(ceil(_value), _target, _pass_data, _tween);
		break;
		case 2: _data[0](ceil(_value), _target);					break;
		case 3: _target[$ _data[0]] = ceil(_value);				break;
		case 4: variable_global_set(_data[0], ceil(_value));		break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = ceil(_value);	break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = ceil(_value);	break;
		}
	});

	TPFuncShared(TPFloor, function(_value, _target, _data, _tween) 
	{	
		/*
			Example:
				TweenFire("$", 60, TPFloor("x"), x, mouse_x)
		*/
		if (is_undefined(_data[1]))
		{
			var _prop = _data[0];
			if (is_array(_prop)) // ?
			{
				_prop[@ 1] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 1] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 1] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 1] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 1] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 1] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
			
		switch(_data[1])
		{
		case 1:
			var _array = _data[0];
			var _pass_data;
			var _length = array_length(_array)-1;
	
			if (_length == 1)
			{	
				_pass_data = _array[1];
			}
			else
			{
				_pass_data = array_create(_length);
				array_copy(_pass_data, 0, _array, 1, _length);
			}
	
			var _script = _array[0];
			_script(floor(_value), _target, _pass_data, _tween);
		break;
		case 2: _data[0](floor(_value), _target);					break;
		case 3: _target[$ _data[0]] = floor(_value);				break;
		case 4: variable_global_set(_data[0], floor(_value));		break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = floor(_value);	break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = floor(_value);	break;
		}
	});

	// TPRound()
	TPFuncShared(TPRound, function(_value, _target, _data, _tween) 
	{	
		/*
			Example:
				TweenFire("$", 60, TPRound("x"), x, mouse_x)
		*/
		if (is_undefined(_data[1]))
		{	
			var _prop = _data[0];
			if (is_array(_prop)) // ?
			{
				_prop[@ 1] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 1] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 1] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 1] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 1] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 1] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
			
		switch(_data[1])
		{
		case 1:
			var _array = _data[0];
			var _pass_data;
			var _length = array_length(_array)-1;
	
			if (_length == 1)
			{	
				_pass_data = _array[1];
			}
			else
			{
				_pass_data = array_create(_length);
				array_copy(_pass_data, 0, _array, 1, _length);
			}
	
			var _script = _array[0];
			_script(round(_value), _target, _pass_data, _tween);
		break;
		case 2: _data[0](round(_value), _target);					break;
		case 3: _target[$ _data[0]] = round(_value);				break;
		case 4: variable_global_set(_data[0], round(_value));		break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = round(_value);	break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = round(_value);	break;
		}
	});
	
	TPFuncShared(TPShake, function(_value, _target, _data, _tween) 
	{	
		/*
			Example:
				TweenFire("$", 60, TPShake("x", 25), x, mouse_x)
		*/

		if (is_undefined(_data[2]))
		{
			var _prop = _data[0];
			
			if (is_array(_prop)) // ?
			{
				_prop[@ 2] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 2] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 2] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 2] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 2] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 2] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
			
		// "SHAKE" the final _value
		if (_tween[TWEEN.TIME] > 0 && _tween[TWEEN.TIME] < _tween[TWEEN.DURATION])
		{
			_value += random_range(-_data[1], _data[1]);
		}
			
		switch(_data[2])
		{
		case 1:
			var _array = _data[0];
			var _pass_data;
			var _length = array_length(_array)-1;
	
			if (_length == 1)
			{	
				_pass_data = _array[1];
			}
			else
			{
				_pass_data = array_create(_length);
				array_copy(_pass_data, 0, _array, 1, _length);
			}
	
			var _script = _array[0];
			_script(_value, _target, _pass_data, _tween);
		break;
		case 2: _data[0](_value, _target);					break;
		case 3: _target[$ _data[0]] = _value;				break;
		case 4: variable_global_set(_data[0], _value);	break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = _value; break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = _value;	break;
		}
	});

	TPFuncShared(TPSnap, function(_value, _target, _data, _tween) 
	{	
		/*
			Example:
				TweenFire("$", 60, TPSnap("x", 32), x, mouse_x)
		*/

		if (is_undefined(_data[2]))
		{
			var _prop = _data[0];
			if (is_array(_prop)) // ?
			{
				_prop[@ 2] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 2] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 2] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 2] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 2] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 2] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
			
		// "SNAP" the final _value
		//_value -= _value % _data[1];
		_value = 10000 * _value div (10000*_data[1]) * (10000*_data[1]) / 10000; // This can be more accurate than modulus
			
		switch(_data[2])
		{
		case 1:
			var _array = _data[0];
			var _pass_data;
			var _length = array_length(_array)-1;
	
			if (_length == 1)
			{	
				_pass_data = _array[1];
			}
			else
			{
				_pass_data = array_create(_length);
				array_copy(_pass_data, 0, _array, 1, _length);
			}
	
			var _script = _array[0];
			_script(_value, _target, _pass_data, _tween);
		break;
		case 2: _data[0](_value, _target);					break;
		case 3: _target[$ _data[0]] = _value;				break;
		case 4: variable_global_set(_data[0], _value);	break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = _value; break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = _value;	break;
		}
	});
	#endregion
	
	#region DATA STRUCTURE PROPERTIES
	
	TPFuncShared(TPArray, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0])) 
		{ 
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		array_set(_data[0], _data[1], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0])) 
		{ 
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return _data[0][_data[1]]; 
	});

	TPFuncShared(TPList, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_list_replace(_data[0], _data[1], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
	
		return ds_list_find_value(_data[0], _data[1]);
	});

	TPFuncShared(TPGrid, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_grid_set(_data[0], _data[1], _data[2], _value);
	}, 
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return ds_grid_get(_data[0], _data[1], _data[2]);
	});

	TPFuncShared(TPMap, 
	function(_value, _target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		ds_map_replace(_data[0], _data[1], _value);
	},
	function(_target, _data) 
	{
		if (is_string(_data[0]))
		{
			_data[@ 0] = _target[$ _data[0]] != undefined ? _target[$ _data[0]] : variable_global_get(_data[0]);
		}
		
		return ds_map_find_value(_data[0], _data[1]);
	});
	#endregion
	
	#region SPECIAL PROPERTIES
	
	TPFuncShared(TPTarget, 
	function(_value, _target, _variable) 
	{
		_target = _variable[1];
	
		if (is_struct(_target))
		{
			_target.ref[$ _variable[0]] = _value;
		}
		else
		{
			_target[$ _variable[0]] = _value;
		}
	}, 
	function(_target, _data, _tween)
	{
		if (is_struct(_data[1]))
		{
			return (_data[1].ref[$ _data[0]]);
		}
		else
		{
			return _data[1].id[$ _data[0]]; // id might be here to prevent return error??
		}
	});

	TPFuncShared(TPUser, 
	function(_value, _target, _data) 
	{
		TWEEN_USER_VALUE = _value;
		TWEEN_USER_TARGET = _target;
		TWEEN_USER_DATA = _data[1];
		
		if (TGMX_OPTIMISE_USER)
		{
			event_perform_object(_target.object_index, ev_other, ev_user0+_data[0]);
		}
		else
		with(TWEEN_USER_TARGET)
		{
			event_user(_data[0]);
		}
	}, 
	function(_target, _data) 
	{
		TWEEN_USER_GET = 1;
		TWEEN_USER_TARGET = _target;
		TWEEN_USER_DATA = _data[1];
		
		if (TGMX_OPTIMISE_USER)
		{
			event_perform_object(TWEEN_USER_TARGET.object_index, ev_other, ev_user0+_data[0]);
		}
		else
		with(TWEEN_USER_TARGET)
		{
			event_user(_data[0]);
		}
		
		_data = TWEEN_USER_GET; // Repurpose '_data' to avoid var overhead
		TWEEN_USER_GET = 0;
		return _data;
	});

	TPFuncSharedNormal(TPCol, 
	function(_value, _target, _data, _tween)
	{
		if (is_undefined(_data[3]))
		{
			var _prop = _data[0];
			
			if (is_array(_prop)) // ?
			{
				_prop[@ 3] = 1;
			}
			else // Property Setter Built
			if (ds_map_exists(global.TGMX.PropertySetters, _prop))
			{
				_data[@ 3] = 2;
				_data[@ 0] = global.TGMX.PropertySetters[? _prop];
			}
			else
			if (_target[$ _prop] != undefined) // Assume instance/struct
			{
				_data[@ 3] = 3;
			}
			else // Assume string property
			{	// global
				if (string_pos("global.", _prop))
				{
					_data[@ 3] = 4;
					_data[@ 0] = string_replace(_prop, "global.", "");
				}
				else // self
				if (string_pos("self.", _prop))
				{
					_data[@ 3] = 5;
					_data[@ 0] = string_replace(_prop, "self.", "");
				}
				else // other
				if (string_pos("other.", _prop))
				{
					_data[@ 3] = 6;
					_data[@ 0] = string_replace(_prop, "other.", "");
				}
				else
				{
					show_error("Advanced dot notation is not yet supported by this function!", false);
				}
			}
		}
		
		switch(_data[3])
		{
		case 2: _data[0](merge_colour(_data[1], _data[2], _value), _target); break;
		case 3: _target[$ _data[0]] = merge_colour(_data[1], _data[2], _value); break;
		case 4: variable_global_set(_data[0], merge_colour(_data[1], _data[2], _value)); break;
		case 5: _tween[TWEEN.CALLER][$ _data[0]] = merge_colour(_data[1], _data[2], _value); break;
		case 6: _tween[TWEEN.OTHER][$ _data[0]] = merge_colour(_data[1], _data[2], _value);	break;
		}
	});

	TPFuncShared(TPPath,
	function(_amount, _target, _path_data, _tween) // SETTER
	{
		var _path, _xstart, _ystart, _xrelative, _yrelative;
		
		if (is_real(_path_data))
		{	// ABSOLUTE
			_path = _path_data;
			_xstart = path_get_x(_path, 0);
			_ystart = path_get_y(_path, 0);
			_xrelative = 0;
			_yrelative = 0;
		}
		else
		{
			_path = _path_data[0];
			_xstart = path_get_x(_path, 0);
			_ystart = path_get_y(_path, 0);
		
			if (array_length(_path_data) == 3)
			{
				_xrelative = _path_data[1] - _xstart;
				_yrelative = _path_data[2] - _ystart;
			}
			else
			if (_path_data[1]) // Absolute
			{
				_xrelative = 0;
				_yrelative = 0;
			}
			else
			{
				_xrelative = _target.x - _xstart;
				_yrelative = _target.y - _ystart;
				_path_data[@ 1] = _target.x; // Right... if I don't do this, it'll always use the update x/y position to offset.. which is wrong!
				_path_data[@ 2] = _target.y;
			}
		}
	
		if (_tween[TWEEN.MODE] == TWEEN_MODE_REPEAT)
		{
			var _xDif = path_get_x(_path, 1) - _xstart;
			var _yDif = path_get_y(_path, 1) - _ystart;
	            
			if (_amount >= 0)
			{   
				_xrelative += _xDif * floor(_amount); 
				_yrelative += _yDif * floor(_amount);
				_amount = _amount % 1;
			}
			else 
			if (_amount < 0)
			{
				_xrelative += _xDif * ceil(_amount-1);
				_yrelative += _yDif * ceil(_amount-1);
				_amount = 1 + _amount % 1;
			}
				
			_target.x = path_get_x(_path, _amount) + _xrelative;
			_target.y = path_get_y(_path, _amount) + _yrelative;
		}
		else
		if (_amount > 0)
		{
			if (path_get_closed(_path) || _amount < 1)
			{
				_target.x = path_get_x(_path, _amount % 1) + _xrelative;
				_target.y = path_get_y(_path, _amount % 1) + _yrelative;
			}
			else
			{
				var _length = path_get_length(_path) * (abs(_amount)-1);
				var _direction = point_direction(path_get_x(_path, 0.999), path_get_y(_path, 0.999), path_get_x(_path, 1), path_get_y(_path, 1));
	                
				_target.x = path_get_x(_path, 1) + _xrelative + lengthdir_x(_length, _direction);
				_target.y = path_get_y(_path, 1) + _yrelative + lengthdir_y(_length, _direction);
			}
		}
		else 
		if (_amount < 0)
		{
			if (path_get_closed(_path))
			{
				_target.x = path_get_x(_path, 1+_amount) + _xrelative;
				_target.y = path_get_y(_path, 1+_amount) + _yrelative;
			}
			else
			{
				var _length = path_get_length(_path) * abs(_amount);
				var _direction = point_direction(_xstart, _ystart, path_get_x(_path, 0.001), path_get_y(_path, 0.001));
	                
				_target.x = _xstart + _xrelative - lengthdir_x(_length, _direction);
				_target.y = _ystart + _yrelative - lengthdir_y(_length, _direction);
			}
		}
		else // _amount == 0
		{
			_target.x = _xstart + _xrelative;
			_target.y = _ystart + _yrelative;
		}
	},
	function(_target, _data, _tween) // GETTER
	{
		return _target.path_position;	
	});
	#endregion

	#region AUTO PROPERTIES

	// Default global property setter
	global.TGMX.Variable_Global_Set = function(_value, _null, _variable) 
	{
		return variable_global_set(_variable, _value);
		_null = 0; // Prevent complaint about unused 'null' (_target)
	}


	// Default instance property setter
	global.TGMX.Variable_Instance_Set = function(_value, _target, _variable) 
	{
		_target[$ _variable] = _value;
	}


	// This is used for dot . syntax
	global.TGMX.Variable_Dot_Notation_Set = function(_value, _target, _data) 
	{
		_target = _data[0]; // We don't use the ACTUAL _tween _target
			
		if (_data[3] == undefined) // See if we haven't set extended _data yet for execution control
		{
			static str_dollar = "$";
				
			if (is_real(_target)) // INSTANCE TARGET
			{
				// METHOD
				if (_target[$ str_dollar+_data[1]] != undefined)
				{
					_data[@ 3] = 1;
					_data[@ 1] = str_dollar+_data[1];
				}
				else // FUNCTION
				if (ds_map_exists(global.TGMX.PropertySetters, _data[1]))
				{
					_data[@ 3] = 2;
					_data[@ 1] = global.TGMX.PropertySetters[? _data[1]];
				}
				else // DYNAMIC
				{
					_data[@ 3] = 3;
				}
			}
			else // STRUCT TARGET
			{
				// METHOD
				if (_target.ref[$ str_dollar+_data[1]] != undefined)
				{
					_data[@ 3] = 4;
					_data[@ 1] = str_dollar+_data[1];
				}
				else // FUNCTION
				if (ds_map_exists(global.TGMX.PropertySetters, _data[1]))
				{
					_data[@ 3] = 5;
					_data[@ 1] = global.TGMX.PropertySetters[? _data[1]];
				}
				else // DYNAMIC
				{
					_data[@ 3] = 6;
				}
			}
		}
			
		// PROCESS TYPE
		switch(_data[3])
		{
		case 1: _target[$ _data[1]](_value, _target, _data[2]); break;			// TARGET | UNIQUE METHOD (TPFunc)
		case 2: _data[1](_value, _target, _data[2]); break;						// TARGET | FUNCTION (TPFuncShared)
		case 3: _target[$ _data[1]] = _value; break;							// TARGET | DYNAMIC
		case 4: _target.ref[$ _data[1]](_value, _target.ref, _data[2]); break;	// STRUCT | UNIQUE METHOD (TPFunc)
		case 5: _data[1](_value, _target.ref, _data[2]); break;					// STRUCT | FUNCTION (TPFuncShared)
		case 6: _target.ref[$ _data[1]] = _value; break;						// STRUCT | DYNAMIC
		}
	}
	#endregion
}


// NOTE: Do not try to optimise these checks. They need to be checked each time anyway.
// NOTE: Keep this as a function to improve performance!!
/// @ignore
function TGMX_Variable_Get(_target, _variable, _caller, _caller_other) 
{		
	static _ = TGMX_Begin();
	static STR_DOT = ".";
	static STR_SELF = "self";
	static STR_OTHER = "other";
	static STR_GLOBAL = "global";
	static STR_AMPERSAND = "&";
	
	// ADVANCED ARRAY
	if (is_array(_variable))
	{	
		// SCRIPT -- Return
		if (ds_map_exists(global.TGMX.PropertyGetters, _variable[0])) 
		{
			return global.TGMX.PropertyGetters[? _variable[0]](_target, _variable[1]);
		}

		// Get _variable string from advanced _data and keep executing below...
		_variable = _variable[1];
		// Get _variable string from inner array if WE MUST GO DEEPER! Muhahaha (I'm ok)
		if (is_array(_variable)) { _variable = _variable[0]; }
	}

	// METHOD (TPFunc)
	if (_target[$ STR_AMPERSAND+_variable] != undefined)
	{	
		return _target[$ STR_AMPERSAND+_variable](_target, _variable);
	}

	// FUNCTION
	if (ds_map_exists(global.TGMX.PropertyGetters, _variable)) 
	{
		return global.TGMX.PropertyGetters[? _variable](_target);
	}

	// INSTANCE
	if (_target[$ _variable] != undefined)
	{
		return _target[$ _variable];
	}
	
	// CALLER
	if (_caller[$ _variable] != undefined)
	{
		return _caller[$ _variable];
	}
	
	// GLOBAL
	if (variable_global_exists(_variable)) 
	{
		return variable_global_get(_variable);
	}
	
	// NUMBER
	if (string_byte_at(_variable, 1) <= 57) 
	{
		return real(_variable);
	}
	
	// Extended
	// global.thing.sub_thing
	if (string_count(STR_DOT, _variable) >= 2)
	{
		var _dotPos = string_pos(STR_DOT,_variable);
		var _prefix = string_copy(_variable, 1, _dotPos-1);
		
		_variable = string_copy(_variable, _dotPos+1, 100);
		var _postfix = string_copy(_variable, string_pos(STR_DOT, _variable)+1, 100);
		
		// Object _variable
		if (object_exists(asset_get_index(_prefix)))
		{
			_target = asset_get_index(_prefix).id[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
		}
		else
		switch(_prefix)
		{
			case STR_SELF:
				_target = _caller[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
			break;
			
			case STR_GLOBAL:
				_target = variable_global_get(string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1));
			break;
			
			case STR_OTHER:
				_target = _caller_other[$ string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1)];
			break;
		}
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		// DYNAMIC
		return _target[$ string_copy(_variable, string_pos(STR_DOT, _variable)+1, 100)];
	}
	
	// EXPRESSION -- Short
	var _prefix = string_copy( _variable, 1, string_pos(STR_DOT, _variable)-1 );
	var _postfix = string_copy(_variable, 1+string_pos(STR_DOT, _variable), 100);
	
	// Object _variable
	if (object_exists(asset_get_index(_prefix)))
	{
		return variable_instance_get(asset_get_index(_prefix).id, _postfix);
	}

	// Caller/Self _variable
	if (_prefix == STR_SELF)
	{	
		// METHOD
		if (_caller[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _caller[$ STR_AMPERSAND+_postfix](_caller, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_caller);
		}

		// DYNAMIC
		return _caller[$ _postfix];
	}
	
	// Other _variable
	if (_prefix == STR_OTHER)
	{
		// METHOD
		if (_caller_other[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _caller_other[$ STR_AMPERSAND+_postfix](_caller_other, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_caller_other);
		}
		
		// DYNAMIC
		return _caller_other[$ _postfix];
	}
	
	//
	// I NEED TO ADD OPTIMSED CHECKS HERE!!!
	//
	
	// Global _variable
	if (_prefix == STR_GLOBAL)
	{
		// NOTE: Optimisation check not required here because of Optimisation check above (Teach to use "global.value" with TPFuncShared()
		return variable_global_get(_postfix);
	}
	
	// Target _variable
	if (_target[$ _prefix] != undefined)
	{
		_target = _target[$ _prefix];
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		return _target[$ _postfix];
	}

	// Caller _variable
	if (_caller[$ _prefix] != undefined)
	{
		_target = _caller[$ _prefix];
		
		// METHOD
		if (_target[$ STR_AMPERSAND+_postfix] != undefined)
		{	
			return _target[$ STR_AMPERSAND+_postfix](_target, _postfix);
		}
		
		// FUNCTION
		if (ds_map_exists(global.TGMX.PropertyGetters, _postfix))
		{
			return global.TGMX.PropertyGetters[? _postfix](_target);
		}
		
		// DYNAMIC
		return _target[$ _postfix];
	}

	// Global
	_target = variable_global_get(_prefix);
	return _target[$ _postfix];
}








