/// @desc Process Tween Logic
// Feather disable all


//===================
// CLEAR EVENT MAPS -- USED BY TweenJust*() FUNCTIONS
//===================
var i = -1;
repeat(TWEEN_EV_TOTAL_EVENTS)
{
	if (!ds_map_empty(global.TGMX.EventMaps[++i])) 
	{
		ds_map_clear(global.TGMX.EventMaps[i]);
	}
}

//=======================
// MANAGE DELTA TIMING
//=======================
prevDeltaTime = deltaTime;      // STORE PREVIOUS PRACTICAL DELTA TIME FORMAT
deltaTime = delta_time/1000000; // UPDATE PRACTICAL DELTA TIME VALUE

// LET'S PREVENT DELTA TIME FROM EXHIBITING SPORADIC BEHAVIOUR, SHALL WE?
// IF THE DELTA TIME IS GREATER THAN THE MAX DELTA LIMIT...
if (deltaTime > maxDelta)
{
	deltaTime = deltaRestored ? maxDelta : prevDeltaTime; // USE MAX DELTA IF RESTORED, ELSE USE THE PREVIOUS DELTA TIME VALUE
	deltaRestored = true; // MARK DELTA TIME AS BEING RESTORED
}
else
{
    deltaRestored = false; // CLEAR RESTORED FLAG
}

deltaTime += addDelta; // ADJUST FOR UPDATE INTERVAL DIFFERENCE -- ONLY RELEVANT IF UPDATE INTERVAL NOT REACHED IN PREVIOUS STEP


//=================================
// PROCESS MAIN UPDATE LOOP
//=================================
var _tweens = tweens; // CACHE MAIN TWEENS LIST
inUpdateLoop = true;  // MARK UPDATE LOOP AS BEING PROCESSED

// IF SYSTEM IS ACTIVE
if (isEnabled)
{     
    tick += 1; // INCREMENT STEP TICK
	addDelta = tick < updateInterval ? addDelta+deltaTime : 0; // MAKE ADJUSTMENT FOR DELTA TIME IF UPDATE INTERVAL NOT ACHIEVED
    
    // WHILE THE SYSTEM TICK IS GREATER THAN THE SET STEP UPDATE INTERVAL -- UPDATE FOR DELTA TIMING???
    while (tick >= updateInterval)
    {   
        tick -= updateInterval;						// DECREMENT STEP TICK BY UPDATE INTERVAL VALUE
		var _timeScale = timeScale;					// CACHE TIME SCALE
		var _timeScaleDelta = _timeScale*deltaTime; // CACHE TIME SCALE AFFECTED BY DELTA TIME
		
        // IF SYSTEM TIME SCALE ISN'T "PAUSED"
        if (_timeScale != 0)
        {  
            //========================================
            // PROCESS TWEENS
            //========================================
            var _tIndex = -1; // TWEEN INDEX ITERATOR
			repeat(tweensProcessNumber)
            {	
				 // GET NEXT TWEEN 
				 _tIndex += 1; // (FASTEST INCREMENT FOR YYC)
                var _t = _tweens[| _tIndex];
				
                // STATE IS HOLDING THE TWEEN'S TARGET IF TWEEN IS ACTIVE
				//var _target = _t[TWEEN.STATE];
				var _target = _t[0]; // OPTIMISED
				
				// DON'T PROCESS TWEEN IF TARGET DOESN'T EXIST -- COMPILER WILL STRIP OUT UNUSED SETTINGS
				if (TGMX_USE_TARGETS == TGMX_TARGETS_INSTANCE) // FORCE ONLY INSTANCE TARGET SUPPORT
				{
					if (!instance_exists(_target)) { continue; } // CONTINUE LOOP IF INSTANCE TARGET DOESN'T EXIST
				}
				if (TGMX_USE_TARGETS == TGMX_TARGETS_STRUCT) // FORCE ONLY STRUCT TARGET SUPPORT
				{
					if (!weak_ref_alive(_target)) { continue; } // CONTINUE LOOP IF STRUCT TARGET DOESN'T EXIST
					_target = _target.ref; // GET STRUCT REFERENCE
				}
				if (TGMX_USE_TARGETS == TGMX_TARGETS_DYNAMIC) // USE DYNAMIC INSTANCE/STRUCT TARGET SUPPORT
				{
					if (is_numeric(_target)) // IF INSTANCE TARGET
					{
						if (!instance_exists(_target)) { continue; } // CONTINUE LOOP IF INSTANCE TARGET DOESN'T EXIST
					}
					else // IF STRUCT TARGET
					{
						if (!weak_ref_alive(_target)) { continue; } // CONTINUE LOOP IF STRUCT TARGET DOESN'T EXIST
						_target = _target.ref; // GET STRUCT REFERENCE
					}
				}

				// UPDATE TWEEN'S TIME -- COMPILER WILL STRIP OUT UNUSED SETTINGS
				var _time;
				if (TGMX_USE_TIMING == TGMX_TIMING_STEP) // FORCE ONLY STEP TIMING SUPPORT
				{
					//_time = _t[TWEEN.TIME] + _t[TWEEN.SCALE] * _timeScale * _t[TWEEN.GROUP_SCALE][0];
					_time = _t[5] + _t[4] * _timeScale * _t[11][0];
				}
				if (TGMX_USE_TIMING == TGMX_TIMING_DELTA) // FORCE ONLY DELTA TIMING SUPPORT
				{
					//_time = _t[TWEEN.TIME] + _t[TWEEN.SCALE] * _timeScaleDelta * _t[TWEEN.GROUP_SCALE][0];
					_time = _t[5] + _t[4] * _timeScaleDelta * _t[11][0]; // OPTIMISED
				}
				if (TGMX_USE_TIMING == TGMX_TIMING_DYNAMIC) // DYNAMIC STEP/DELTA TIMING SUPPORT
				{
					//_time = _t[TWEEN.TIME] + _t[TWEEN.SCALE] * (_t[TWEEN.DELTA] ? _timeScaleDelta : _timeScale) * _t[TWEEN.GROUP_SCALE][0];
					_time = _t[5] + _t[4] * (_t[3] ? _timeScaleDelta : _timeScale) * _t[11][0]; // OPTIMISED
				}	
				
                // IF TWEEN TIME IS WITHIN 0 AND DURATION
                //if (_time > 0 && _time < _t[TWEEN.DURATION])
				if (_time < _t[1] && _time > 0) // OPTIMISED -- CHECK TIME AGAINST DURATION FIRST (FASTER FOR YYC)
                {
					// Assign updated time
                    //_t[@ TWEEN.TIME] = _time;
					_t[@ 5] = _time;
					
					// PROCESS TWEEN
					//TGMX_TweenProcess(_t, _time, _t[TWEEN.PROPERTY_DATA], _target); continue;
					
					// ***** INLINE VERSION OF TGMX_TweenProcess() FOR IMPROVED PERFORMANCE *****
					//var _d = _t[TWEEN.PROPERTY_DATA]; // CACHE TWEEN PROPERTY DATA
					var _d = _t[8]; // OPTIMISED
					
					switch(_d[0]) // PROPERTY COUNT
					{
					case 1:
						//if (is_method(_t[TWEEN.EASE])) { _d[1](_t[TWEEN.EASE](_time, _d[2], _d[3], _t[TWEEN.DURATION], _t), _target, _d[4], _t); } // note: _d[4] is variable string name
						//else						     { _d[1](_d[2] + _d[3]*animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]), _target, _d[4], _t); }
						// OPTIMISED
						if (is_method(_t[7])) { _d[1](_t[7](_time, _d[2], _d[3], _t[1], _t), _target, _d[4], _t); } // note: _d[4] is variable string name
						else				  { _d[1](_d[2]+animcurve_channel_evaluate(_t[7], _time/_t[1])*_d[3], _target, _d[4], _t); }
					break;
					
					case 2:
						//_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]); // OPTIMISED
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
						_d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					break;
					
					case 3:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					break;
					
					case 4:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
						_d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					break;
					
					case 5:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					break;
					
					case 6:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					break;
					
					case 7:
					    _time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
					break;
					
					case 8:
					    _time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
						_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
					break;
					
					case 9:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
						_d[33](_time*_d[35]+_d[34], _target, _d[36], _t);
					break;
					
					case 10:
						_time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]);
					    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
					    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
					    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
					    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
					    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
					    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
					    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
						_d[29](_time*_d[31]+_d[30], _target, _d[32], _t);
						_d[33](_time*_d[35]+_d[34], _target, _d[36], _t);
						_d[37](_time*_d[39]+_d[38], _target, _d[40], _t);
					break;
					
					case 0: 
						// Break out for tweens with no properties
					break;
					
					default: // Handle "unlimited" property count
						//var _time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
						var _time = is_method(_t[7]) ? _t[7](_time, 0, 1, _t[1], _t) : animcurve_channel_evaluate(_t[7], _time/_t[1]); // OPTIMISED
						var i = 1;
						repeat(_d[0])
						{
							_d[i](_time*_d[i+2]+_d[i+1], _target, _d[i+3], _t);
							i += 4;
						}
					break;
					}
				}
                else // Tween has reached start or destination
				{
					TweenHasReachedBounds(_t, _target, _time, _timeScaleDelta);
				}
            }
			
			
			//==================================
            // Process Delays
            //==================================
            var _delayedTweens = delayedTweens; // Cache list of delayed tweens
			_tIndex = -1; // Reset tween index iterator
            repeat(delaysProcessNumber)
            {
				// GET NEXT TWEEN FROM DELAYED TWEENS LIST
				_tIndex += 1;
                var _t = _delayedTweens[| _tIndex];
    
                // IF tween instance exists AND delay is NOT destroyed
                if (_t[TWEEN.STATE] == TWEEN_STATE.DELAYED && (is_real(_t[TWEEN.TARGET])) ? instance_exists(_t[TWEEN.TARGET]) : weak_ref_alive(_t[TWEEN.TARGET]))
                { 
					// Decrement delay timer -- TODO: Add support for group scales
					_t[@ TWEEN.DELAY] = _t[TWEEN.DELAY] - abs(_t[TWEEN.SCALE]) * (_t[TWEEN.DELTA] ? _timeScaleDelta : _timeScale)  * _t[TWEEN.GROUP_SCALE][0];
					
                    // IF the delay timer has expired
                    if (_t[TWEEN.DELAY] <= 0)
                    {	
						// Remove tween from delay list
                        ds_list_delete(_delayedTweens, _tIndex--); 
						// Set time to delay overflow
						_t[@ TWEEN.TIME] = abs(_t[TWEEN.DELAY]);
						// Indicate that delay has been removed from delay list
                        _t[@ TWEEN.DELAY] = 0;										
                        // Execute FINISH DELAY event
						TGMX_ExecuteEvent(_t, TWEEN_EV_FINISH_DELAY);
						// Set tween as active 
                        _t[@ TWEEN.STATE] = _t[TWEEN.TARGET];  
						// Process tween data
						TGMX_TweenPreprocess(_t);
                        // Update property with start value                 
						TGMX_TweenProcess(_t, _t[TWEEN.TIME], _t[TWEEN.PROPERTY_DATA], is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref); // TODO: Verify that overflow is working
						// Execute PLAY event callbacks
						TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
                    }
                }
                else // If delay is marked for removal or tween is destroyed
                if (_t[TWEEN.DELAY] == 0 || _t[TWEEN.STATE] == TWEEN_STATE.DESTROYED)
                {
                    ds_list_delete(_delayedTweens, _tIndex--); // Remove tween from delay list
                }
            }
        }
    }
}

//==================================
// EVENT CLEANER -- This needs to stay above "Passive Tween Cleaner" to prevent errors
//==================================
if (ds_priority_size(eventCleaner))
{
    var _event = ds_priority_delete_min(eventCleaner); // GET EVENT TO CHECK FOR CLEANING

	// CYCLE THROUGH ALL CALLBACKS, EXCEPT THE NEW ONE -- MAKE SURE NOT TO CHECK EVENT STATUS INDEX IN EVENT[0]
    var _cbCheckIndex = ds_list_size(_event);
    repeat(_cbCheckIndex-1)
    {
		var _cb = _event[| --_cbCheckIndex];
		
		if (_cb[TWEEN_CB.TWEEN] == TWEEN_NULL) 
		{
			ds_list_delete(_event, _cbCheckIndex); 
		}
		else
		{
			var _cbTarget = _cb[TWEEN_CB.TARGET];
			
			if (is_real(_cbTarget)) // INSTANCE TARGET
			{	
				if (!instance_exists(_cbTarget)) // CHECK IF TARGET DOESN'T EXIST
			    {	
					instance_activate_object(_cbTarget); // ATTEMPT TO ACTIVATE INSTANCE
		    
				    if (instance_exists(_cbTarget)) // IF TARGET EXISTS, PUT INSTANCE BACK TO DEACTIVATED STATE
					{	
				        instance_deactivate_object(_cbTarget);
				    }
				    else // REMOVE CALLBACK FROM EVENT
				    {	
						ds_list_delete(_event, _cbCheckIndex); 
			    	}
			    }
			}
			else //STRUCT TARGET
			if (!weak_ref_alive(_cbTarget))
			{
				ds_list_delete(_event, _cbCheckIndex);
			}
		}
    }
}


//=========================================
// PASSIVE TWEEN CLEANER
//=========================================
// CHECK TO SEE IF SYSTEM IS BEING FLUSHED
// ELSE CLAMP NUMBER OF CLEANING ITERATIONS
var _cleanIterations;
if (flushDestroyed)
{
    flushDestroyed = false;                   // CLEAR "FLUSH" FLAG
    autoCleanIndex = ds_list_size(_tweens);   // SET STARTING CLEAN INDEX TO LIST SIZE
    _cleanIterations = ds_list_size(_tweens); // SET NUMBER OF ITERATIONS TO LIST SIZE
}
else
{
    _cleanIterations = min(autoCleanIterations, autoCleanIndex, ds_list_size(_tweens)); // CLAMP!
}

// START THE CLEANING!
repeat(_cleanIterations)
{   
    // GET NEXT TWEEN TO CHECK FOR REMOVAL
	autoCleanIndex -= 1;
    var _t = _tweens[| autoCleanIndex];
    
    // IF TWEEN TARGET DOES NOT EXIST...
    if (is_numeric(_t[TWEEN.TARGET]))
	{
		if (!instance_exists(_t[TWEEN.TARGET]))
	    {
	        // ATTEMPT TO ACTIVATE TARGET INSTANCE
			// IF INSTANCE NOW EXISTS, PUT IT BACK TO DEACTIVATED STATE
	        if (instance_exists(_t[TWEEN.TARGET]))
	        {
	            instance_deactivate_object(_t[TWEEN.TARGET]);
	        }
	        else // HANDLE TWEEN DESTRUCTION...
	        {
				// REMOVE TWEEN FROM TWEENS LIST
	            ds_list_delete(_tweens, autoCleanIndex);  
				// SET TWEEN STATE AS DESTROYED
				_t[@ TWEEN.STATE] = TWEEN_STATE.DESTROYED;
	            
				// INVALIDATE TWEEN HANDLE
	            if (ds_map_exists(global.TGMX.TweenIndexMap, _t[TWEEN.ID]))
	            {
	                ds_map_delete(global.TGMX.TweenIndexMap, _t[TWEEN.ID]);
				}
	            
				// DESTROY TWEEN EVENTS IF EVENTS MAP EXISTS
	            if (_t[TWEEN.EVENTS] != -1)
	            {
	                ds_map_destroy(_t[TWEEN.EVENTS]); // DESTROY EVENTS MAP -- INTERNAL LISTS ARE MARKED
	            }
	        }
	    }
	}
	else
	{
		// LET'S SEE IF THE STRUCT IS 'DEAD'
		if (!weak_ref_alive(_t[TWEEN.TARGET]))
		{
			// REMOVE TWEEN FROM TWEENS LIST
            ds_list_delete(_tweens, autoCleanIndex); 
			// SET TWEEN STATE AS DESTROYED
			_t[@ TWEEN.STATE] = TWEEN_STATE.DESTROYED; 
            
			// INVALIDATE TWEEN HANDLE
            if (ds_map_exists(global.TGMX.TweenIndexMap, _t[TWEEN.ID]))
            {
                ds_map_delete(global.TGMX.TweenIndexMap, _t[TWEEN.ID]);
			}
            
			// DESTROY TWEEN EVENTS IF EVENTS MAP EXISTS
	        if (_t[TWEEN.EVENTS] != -1)
	        {
	            ds_map_destroy(_t[TWEEN.EVENTS]); // DESTROY EVENTS MAP -- INTERNAL LISTS ARE MARKED
	        }
		}
	}
}

// PLACE AUTO CLEAN INDEX TO SIZE OF TWEENS LIST IF BELOW OR EQUAL TO 0
if (autoCleanIndex <= 0) { autoCleanIndex = ds_list_size(_tweens); }

// INDICATE THAT WE ARE FINISHED PROCESSING THE MAIN UPDATE LOOP
inUpdateLoop = false;

// STATE CHANGER
repeat(ds_queue_size(stateChanger) div 2)
{
	var _t = ds_queue_dequeue(stateChanger);
	var _state = ds_queue_dequeue(stateChanger);
	
	if (TweenExists(_t))
	{
		_t[@ TWEEN.STATE] = _state;
	}
}






