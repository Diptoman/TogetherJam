// Feather disable all

/*
Required:
	TweenExists
	TweenStop
	TweenPause
	TweenResume
	TweenDestroy
	TweenDestroyWhenDone
	
Safe to delete:
	TweenIsActive
	TweenIsPlaying
	TweenIsPaused
	TweenIsResting
	TweenJustStarted
	TweenJustFinished
	TweenJustStopped
	TweenJustPaused
	TweenJustResumed
	TweenJustRested
	TweenJustContinued
	TweenReverse
	TweenFinish
	TweenFinishDelay
*/

var _; // USED TO HIDE SYNTAX WARNINGS FOR NON-FEATHER ENVIRONMENT


function TweenExists(_t) 
{	
	/// @function TweenExists(tween)
	/// @description Checks if tween exists
	
	static _ = SharedTweener();
	
	if (is_real(_t)) // TWEEN ID
	{
	    if (ds_map_exists(global.TGMX.TweenIndexMap, _t))
	    {
	        _t = global.TGMX.TweenIndexMap[? _t];
	    }
	    else
	    {
	        return false;
	    }
	}
	else
	if (is_array(_t)) // RAW TWEEN
	{
	    if (_t[TWEEN.STATE] == TWEEN_STATE.DESTROYED) 
		{ 
			return false; 
		}
	}
	else
	if (_t == undefined) // NULL
	{
	    return false;
	}
    
	// _t now means target... this is an optimisation trick to avoid use of local vars
	_t = _t[TWEEN.TARGET];
	
	if (is_real(_t))
	{
		if (instance_exists(_t)) { return true; }

		instance_activate_object(_t);

		if (instance_exists(_t))
		{
		    instance_deactivate_object(_t);
		    return true;
		}
	}
	else
	if (weak_ref_alive(_t))
	{
		return true;
	}
	
	return false;
}


function TweenIsActive(_t)
{	
	/// @function TweenIsActive(tween)
	/// @descriptionChecks if tween is active -- Returns true if tween is playing OR actively processing a delay
	
	static _ = SharedTweener();
	
	if (is_real(_t))
	{
		_t = TGMX_FetchTween(_t);
		return is_undefined(_t) ? false : (is_struct(_t[TWEEN.STATE]) ||  _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] == TWEEN_STATE.DELAYED);
	}
	else
	if (is_array(_t))
	{
		var _tweens = _t;
		var _tIndex = -1;
		repeat(array_length(_tweens))
		{
			_t = TGMX_FetchTween(_tweens[++_tIndex]);
			if (!is_undefined(_t) && (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] == TWEEN_STATE.DELAYED))
			{
				return true;	
			}
		}
	}
	else // Check if any tween is active
	if (_t != undefined)
	{
		var _tweens = SharedTweener().tweens;
		var _tIndex = -1; // Tween index iterator
		repeat(ds_list_size(_tweens))
        {
			_t = _tweens[| ++_tIndex];
			if (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] == TWEEN_STATE.DELAYED)
			{
				return true;	
			}
		}
	}
	
	return false;
}_=TweenIsActive;


function TweenIsPlaying(_t)
{	
	/// @function TweenIsPlaying(tween)
	/// @description Checks if tween is playing
	
	static _ = SharedTweener();
	
	if (is_real(_t))
	{
		_t = TGMX_FetchTween(_t);
		return is_undefined(_t) ? false : (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0);
	}
	else
	if (is_array(_t))
	{
		var _tweens = _t;
		var _tIndex = -1;
		repeat(array_length(_tweens))
		{
			_t = TGMX_FetchTween(_tweens[++_tIndex]);
			if (!is_undefined(_t) && (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0))
			{
				return true;	
			}
		}
	}
	else
	if (_t != undefined)
	{
		var _tweens = SharedTweener().tweens;
		var _tIndex = -1; // Tween index iterator
		repeat(ds_list_size(_tweens))
        {
			if (_tweens[| ++_tIndex][TWEEN.STATE] >= 0)
			{
				return true;	
			}
		}
	}
	
	return false;
}_=TweenIsPlaying;


function TweenIsPaused(_t)
{	
	/// @function TweenIsPaused(tween)
	/// @description Checks if tween is paused
	
	_t = TGMX_FetchTween(_t);
	return is_undefined(_t) ? false : _t[TWEEN.STATE] == TWEEN_STATE.PAUSED;
}_=TweenIsPaused;


function TweenIsResting(_t)
{	
	/// @function TweenIsResting(tween)
	/// @description Checks if tween is resting
	
	_t = TGMX_FetchTween(_t);
	if (is_array(_t)) 
	{ 
		if (is_array(_t[TWEEN.REST]))
		{
			return _t[TWEEN.REST][_t[TWEEN.TIME] > 0] < 0;	
		}
		else
		{
			return _t[TWEEN.REST] < 0;
		}
	}
	
	return false;
}_=TweenIsResting;


function TweenJustStarted(_t)
{	
	/// @function TweenJustStarted(tween)
	/// @description Checks if tween just started playing in current step
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_PLAY], _t);
}_=TweenJustStarted;


function TweenJustFinished(_t)
{	
	/// @function TweenJustFinished(tween)
	/// @description Checks to see if the tween just finished in current step
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_FINISH], _t);
}_=TweenJustFinished;
	

function TweenJustStopped(_t)
{	
	/// @function TweenJustStopped(tween)
	///	@description Checks if tween just stopped in current step	
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_STOP], _t);
}_=TweenJustStopped;


function TweenJustPaused(_t)
{	
	/// @function TweenJustPaused(tween)
	/// @description Checks if tween was just paused in current step	
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_PAUSE], _t);
}_=TweenJustPaused;


function TweenJustResumed(_t)
{	
	/// @function TweenJustResumed(tween)
	/// @description Checks if tween was just resumed in current step
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_RESUME], _t);
}_=TweenJustResumed;


function TweenJustRested(_t) 
{	
	/// @function TweenJustRested(tween)
	/// @description Checks if tween started to rest in current step
	
	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_REST], _t);	
}_=TweenJustRested;


function TweenJustContinued(_t)
{	
	/// @function TweenJustContinued(tween)
	/// @description Checks if tween just continued in current step

	static _ = SharedTweener();
	return ds_map_exists(global.TGMX.EventMaps[TWEEN_EV_CONTINUE], _t);
}_=TweenJustContinued;


function TweenStop(_t)
{	
	/// @function TweenStop(tween[s])
	/// @description Stops selected tween[s]
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] <= TWEEN_STATE.PAUSED)
	    {
	        _t[@ TWEEN.STATE] = TWEEN_STATE.STOPPED;
        
	        if (_t[TWEEN.DELAY] >= 0) // NOTE: Careful with the -1 jump delays...
	        {
	            _t[@ TWEEN.DELAY] = 0;   
	            TGMX_ExecuteEvent(_t, TWEEN_EV_STOP_DELAY);
	        }
	        else
	        {
	            TGMX_ExecuteEvent(_t, TWEEN_EV_STOP);
	        }
            
	        if (_t[TWEEN.DESTROY]) { TweenDestroy(_t); }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenStop);
	}
}


function TweenPause(_t)
{
	/// @function TweenPause(tween[s])
	/// @description Pauses selected tween[s]
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0) 
		{
	        _t[@ TWEEN.STATE] = TWEEN_STATE.PAUSED;
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PAUSE);
	    }
		else 
		if (_t[TWEEN.STATE] == TWEEN_STATE.DELAYED) 
		{
	        _t[@ TWEEN.STATE] = TWEEN_STATE.PAUSED;
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PAUSE_DELAY);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenPause);
	}
}


function TweenResume(_t) 
{	
	/// @function TweenResume(tween[s])
	/// @description Resumes selected tween[s]
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{		
	    if (_t[TWEEN.STATE] == TWEEN_STATE.PAUSED)
	    {		
	        if (_t[TWEEN.DELAY] > 0)
	        {
	            _t[@ TWEEN.STATE] = TWEEN_STATE.DELAYED;
	            TGMX_ExecuteEvent(_t, TWEEN_EV_RESUME_DELAY);
	        }
	        else
	        {
	            _t[@ TWEEN.STATE] = _t[TWEEN.TARGET];
	            TGMX_ExecuteEvent(_t, TWEEN_EV_RESUME);
	        }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenResume);
	}
}


function TweenReverse(_t)
{	
	/// @function TweenReverse(tween[s])
	/// @description Reverses selected tween(s)
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] == TWEEN_STATE.PAUSED)
	    {
	        _t[@ TWEEN.DIRECTION] = -_t[TWEEN.DIRECTION];
	        _t[@ TWEEN.SCALE] = -_t[TWEEN.SCALE];
	        TGMX_ExecuteEvent(_t, TWEEN_EV_REVERSE);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenReverse);
	}
}


function TweenFinish(_t, _callEvent=true, _finishDelay=true, _callDelayEvent=true)
{
	/// @function TweenFinish(tween[s], [call_event?, finish_delay?, call_delay_event?])
	/// @description Finishes selected tween[s]
	/*      
	    INFO:
	        Finishes the specified tween, updating it to its destination.
	        DOES NOT affect tweens using PATROL|LOOP|REPEAT play modes
	        when a specified continue count is not given.
	*/
	
	static _ = SharedTweener();

	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{	// Deal with delays
		if (_t[TWEEN.DELAY] > 0 && _finishDelay)
	    {
			//> Mark delay for removal from delay list
	        _t[@ TWEEN.DELAY] = 0;
	        //> Execute FINISH DELAY event
	        if (_callDelayEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY); }
			//> Set tween as active
	        _t[@ TWEEN.STATE] = _t[TWEEN.TARGET];                
			//> Preprocess tween
			TGMX_TweenPreprocess(_t);
			//> Process tween
			TGMX_TweenProcess(_t, 0, _t[TWEEN.PROPERTY_DATA], is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref);
			//> Execute PLAY event
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	    }
		
		// Return early if tween retained delay
	    if (_t[TWEEN.DELAY] > 0) { return 0; }
    
    	// Let's finish the tween!
	    if (is_struct(_t[TWEEN.STATE]) || _t[TWEEN.STATE] >= 0 || _t[TWEEN.STATE] == TWEEN_STATE.PAUSED)
	    {
	        switch(_t[TWEEN.MODE])
	        {
	        case TWEEN_MODE_ONCE: 
				//> Set time to tween end
				_t[@ TWEEN.TIME] = _t[TWEEN.DURATION];
			break;
	        
			case TWEEN_MODE_BOUNCE: 
				//> Set time to tween start
				_t[@ TWEEN.TIME] = 0; 
			break;
			
			case TWEEN_MODE_PATROL:
				//> Exit script early if count is endless
				if (_t[TWEEN.CONTINUE_COUNT] <= -1) return;
				
				//> Determine start/end based on odd/even count
				if (_t[TWEEN.CONTINUE_COUNT] % 2 == 0) {
					_t[@ TWEEN.TIME] = _t[TWEEN.DIRECTION] == 1 ? _t[TWEEN.DURATION] : 0;
				}
				else {
					_t[@ TWEEN.TIME] = _t[TWEEN.DIRECTION] == 1 ? 0 : _t[TWEEN.DURATION];
				}	
			break;
			
			case TWEEN_MODE_LOOP:
				//> Exit script early if count is endless
				if (_t[TWEEN.CONTINUE_COUNT] <= -1) return;
				//> Set time to tween end
				_t[@ TWEEN.TIME] = _t[TWEEN.DURATION];	
			break;
			
			case TWEEN_MODE_REPEAT:
				//> Exit script early if count is endless
				if (_t[TWEEN.CONTINUE_COUNT] <= -1) return;
				//> Set time to tween end
				_t[@ TWEEN.TIME] = _t[TWEEN.DURATION];
				
				//> Loop through data array and change start positions
				var _data = _t[TWEEN.PROPERTY_DATA];
				var i = -2;
				repeat(_data[0])
				{
					i += 4;
					_data[@ i] += _data[i+1] * _t[TWEEN.CONTINUE_COUNT]; 
				}
			break;
	        }
        
			//> Set tween state as STOPPED
	        _t[@ TWEEN.STATE] = TWEEN_STATE.STOPPED; 
	        //> Update property with start value
			TGMX_TweenProcess(_t, _t[TWEEN.TIME], _t[TWEEN.PROPERTY_DATA], is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref);
	        //> Execute finish event IF set to do so
	        if (_callEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH); }
	        //> Destroy tween if it is set to be destroyed
	        if (_t[TWEEN.DESTROY]) { TweenDestroy(_t); }
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenFinish, _callEvent);
	}
}

	
function TweenFinishDelay(_t, _callEvent=true) 
{	
	/// @function TweenFinishDelay(tween[s], [call_event?])
	/// @description Finishes delay for selected tween[s]
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
	    if (_t[TWEEN.DELAY] > 0)
	    {
			//> Mark delay for removal from delay list
	        _t[@ TWEEN.DELAY] = 0;
	        //> Execute FINISH DELAY event
	        if (_callEvent) { TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY); }
			//> Set tween as active
	        _t[@ TWEEN.STATE] = _t[TWEEN.TARGET];                
			//> Preprocess tween
			TGMX_TweenPreprocess(_t);
			//> Process tween
			TGMX_TweenProcess(_t, 0, _t[TWEEN.PROPERTY_DATA], is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref);
			//> Execute PLAY event
	        TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	    }
	}
	else
	if (is_struct(_t))
	{
	    TGMX_TweensExecute(_t, TweenFinishDelay, _callEvent);
	}
}


function TweenDestroy(_t) 
{	
	/// @function TweenDestroy(tween[s])
	/// @description Manually destroys selected tween[s]
	/*
	    Note: Tweens are always automatically destroyed when their target instance is destroyed.
	*/
	
	static _ = SharedTweener();

	_t = TGMX_FetchTween(_t);

	if (is_array(_t))
	{
		if (_t[TWEEN.STATE] == TWEEN_STATE.DESTROYED)
		{
		    return undefined;
		}
    
		// NOTE: Don't need the extra map-check here, as the handle SHOULD always exist at this point, if reached
	
		// Invalidate tween handle
		ds_map_delete(global.TGMX.TweenIndexMap, _t[TWEEN.ID]);
    
		// NOTE: We don't have to destroy the property list here... that will be done in the auto-cleaner
	
		_t[@ TWEEN.STATE] = TWEEN_STATE.DESTROYED; // Set state as destroyed
		_t[@ TWEEN.ID] = undefined; // Nullify self reference
    
		// Invalidate tween target or destroy target instance depending on destroy mode
		if (_t[TWEEN.DESTROY] == 2)
		{	
			if (is_real(_t[TWEEN.TARGET]))
			{
				// Destroy Target Instance
			    if (instance_exists(_t[TWEEN.TARGET]))
			    {
			        with(_t[TWEEN.TARGET]) instance_destroy(_t[TWEEN.TARGET]);
			    }
			    else
			    {
			        instance_activate_object(_t[TWEEN.TARGET]); // Attempt to activate target by chance it was deactivated
			        with(_t[TWEEN.TARGET]) instance_destroy(); // Attempt to destroy target
			    } 
			}
		}
	
		_t[@ TWEEN.TARGET] = noone; // Invalidate tween target
		return undefined;
	}
	else
	if (is_struct(_t))
	{
		TGMX_TweensExecute(_t, TweenDestroy);
	}

	return undefined;
}


function TweenDestroyWhenDone(_t, _destroy, _kill_target=false)
{
	/// @function TweenDestroyWhenDone(tween[s], destroy?, [kill_target?])
	/// @description Forces tween to be destroyed when finished or stopped
	/// @param	tween[s]		tween id(s)
	/// @param	destroy?		destroy tween[s] when finished or stopped?
	/// @param	[kill_target?]	(optional) destroy target when tween finished or stopped?
	
	static _ = SharedTweener();
	
	_t = TGMX_FetchTween(_t);

	if (_kill_target)
	{
		_destroy = 2;	
	}

	if (is_array(_t))
	{
		_t[@ TWEEN.DESTROY] = _destroy;
	}
	else
	if (is_struct(_t))
	{
		TGMX_TweensExecute(_t, TweenDestroyWhenDone, _destroy);
	}
}





