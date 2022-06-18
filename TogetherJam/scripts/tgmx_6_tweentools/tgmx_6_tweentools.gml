// Feather disable all

/*
	It is safe to delete any function from this script
	or to delete the whole script entirely
*/


function TweensIncludeDeactivated(_include)
{	
	///@function TweensIncludeDeactivated(include?)
	///@description Include tweens with deactivated targets? Used by Tweens() function. Default: false
	
	static _ = TGMX_Begin();
	
	global.TGMX.TweensIncludeDeactivated = _include;
}


function TweenCalc(_t) 
{	
	/// @function TweenCalc(tween, [amount])
	/// @description Returns a calculated value using a tweens current state
	/// @param tween tween id
	/// @param [amount]	(optional) amount between 0-1 or explicit [time] as array -- See examples below
	/*
	    INFO:
	        Returns a calculated value using a tweens current state.
			A real number is returned directly if only one property is tweened.
			An array of real numbers is returned if multiple properties are tweened,
			in the order they were originally supplied to the tween.
        
	    EXAMPLES:
	        // Create defined tween
	        tween = TweenFire(id, EaseInOutQuint, 0, true, 0.0, 10, "", x, mouse_x);
        
	        // Calculate value of tween at its current state
	        x = TweenCalc(tween);
			
			// Calculate a tweens "halfway" value by using an amount (0.0 - 1.0)
			midPoint = TweenCalc(tween, 0.5);
			
			// Calculate using an explicit time by passing time within an array
			value = TweenCalc(tween, [5]);
			
			// Create multi-property tween -- returns array holding values for each property
			tweenXY = TweenFire(id, EaseOutQuad, 0, false, 0, 30, "", x, mouse_x, "", y, mouse_y);
			midPoints = TweenCalc(tweenXY, 0.5);
			var _x = midPoints[0];
			var _y = midPoints[1];
	*/

	static _ = SharedTweener();

	_t = TGMX_FetchTween(_t);
	if (is_undefined(_t)) { return 0; }
	
	var _amount;
	
	if (argument_count == 1) // Return tween's current time amount
	{
		_amount = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_t[TWEEN.TIME], 0, 1, _t[TWEEN.DURATION]) 
											: animcurve_channel_evaluate(_t[TWEEN.EASE], _t[TWEEN.TIME] / _t[TWEEN.DURATION]);
	}
	else
	if (is_real(argument[1])) // Real amount (0-1)
	{
		_amount = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](argument[1], 0, 1, 1)
											: animcurve_channel_evaluate(_t[TWEEN.EASE], argument[1]);
	}
	else
	if (is_array(argument[1])) // Explicit time
	{
		_amount = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](array_get(argument[1],0), 0, 1, _t[TWEEN.DURATION])
											: animcurve_channel_evaluate(_t[TWEEN.EASE], array_get(argument[1],0) / _t[TWEEN.DURATION]);
	}

	var _data = _t[TWEEN.PROPERTY_DATA];
	var _count = array_length(_data) div 4;

	// Handle single property case
	if (_count == 1)
	{
		return lerp(_data[2], _data[2] + _data[3], _amount);
	}
		
	// Otherwise... handle multi-property case
	var _return = array_create(_count);
	var _iReturn = -1;
	var _iStart = 2;
	var _iDest = 3;
		
	repeat(_count)
	{
		_return[++_iReturn] = lerp(_data[_iStart], _data[_iStart]+_data[_iDest], _amount);
		_iStart += 4;
		_iDest += 4;
	}
    
	return _return;
}


function TweenStep(_t, _amount=1)
{
	/// @function TweenStep(tween, amount)
	/// @description Steps a paused tween forward or backward by a set amount
	/// @param tween
	/// @param amount
	
	_t = TGMX_FetchTween(_t);
	
	if (is_array(_t))
	{
		var _sharedTweener = SharedTweener();
		var _timeScale = _sharedTweener.timeScale * _amount; // Cache time scale
		var _timeScaleDelta = _timeScale * _sharedTweener.deltaTime; // Cache time scale affected by delta time
		
	    // IF system time scale isn't "paused"
	    if (_timeScale != 0)
	    {  
	        // Process tween if target/state exists/active
			var _target = _t[TWEEN.TARGET];
			
			if (is_real(_target))
			{
				if (!instance_exists(_target)) return;
			}
			else // is struct
			{
				if (!weak_ref_alive(_target)) return;
				_target = _target.ref;
			}
			
			if (_t[TWEEN.DELAY] <= 0)
			{			
				// Cache updated time value for tween (multiply by relevant scale types (per / global/ group)
				var _time = _t[TWEEN.TIME] + _t[TWEEN.SCALE] * (_t[TWEEN.DELTA] ? _timeScaleDelta : _timeScale) * _t[TWEEN.GROUP_SCALE][0];
				
		        // IF tween is within start/destination
		        if (_time > 0 && _time < _t[TWEEN.DURATION])
		        {
					// Assign updated time
		            _t[@ TWEEN.TIME] = _time;
					// Process tween
					TGMX_TweenProcess(_t, _time, _t[TWEEN.PROPERTY_DATA], _target);
				}
		        else // Tween has reached start or destination
				{
					_sharedTweener.TweenHasReachedBounds(_t, _target, _time, _timeScaleDelta);
				}
			}
			else
			{
				//==================================
		        // Process Delay
		        //==================================
				// Decrement delay timer
				_t[@ TWEEN.DELAY] = _t[TWEEN.DELAY] - abs(_t[TWEEN.SCALE]) * (_t[TWEEN.DELTA] ? _timeScaleDelta : _timeScale) * _t[TWEEN.GROUP_SCALE][0];
					
		        // IF the delay timer has expired
		        if (_t[TWEEN.DELAY] <= 0)
		        {	
					// Set time to delay overflow
					_t[@ TWEEN.TIME] = abs(_t[TWEEN.DELAY]);
					// Indicate that delay has been removed from delay list
		            _t[@ TWEEN.DELAY] = 0;										
		            // Execute FINISH DELAY event
					TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY);
					// Set tween as active 
					if (_t[TWEEN.STATE] != TWEEN_STATE.PAUSED)
					{
						_t[@ TWEEN.STATE] = _t[TWEEN.TARGET];
					}
					// Process tween data
					TGMX_TweenPreprocess(_t);
		            // Update property with start value                 
					TGMX_TweenProcess(_t, _t[TWEEN.TIME], _t[TWEEN.PROPERTY_DATA], _target); // TODO: Verify that overflow is working
					// Execute PLAY event callbacks
					TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
		        }
		    }
		}
	}
	else
	if (is_struct(_t))
	{
		TGMX_TweensExecute(_t, TweenStep, _amount);	
	}	
}




