// [TweenGMX Beta 12]
// Feather disable all

/// QUICK LOOKUP
/// TGMX_Tween | TGMX_TweenPreprocess | TGMX_TweenProcess | TGMX_StringStrip | TGMX_ExecuteEvent

// SET SHARED TWEENER TO BE AUTOMATICALLY CREATED IN FIRST ROOM
room_instance_add(room_first, 0, 0, o_SharedTweener);

/// @ignore
function TGMX_Begin()
{	
	/// @function TGMX_Begin()
	/// @description TGMX ADMIN: Initialization
	
	// MAKE SURE THIS IS FIRED ONLY ONCE
	static __initialized = false;
	if (__initialized) { return 0; }
	__initialized = true;
	
	method_get_index(function(){}); // TEMPORARY FIX
	
	global.TGMX = {}; 
	global.TGMX.SharedTweener = noone;
	global.TGMX.tween_self = undefined;
	global.TGMX.TweenIndexMap = ds_map_create();
	global.TGMX.GroupScales = ds_map_create();
	global.TGMX.PropertySetters = ds_map_create();
	global.TGMX.PropertyGetters = ds_map_create();
	global.TGMX.PropertyNormals = ds_map_create();
	global.TGMX.Cache = ds_map_create();
	global.TGMX.TweenDefault = array_create(TWEEN.DATA_SIZE);
	
	//-----------------------------------------------
	// Declare Default Global System-Wide Settings
	//-----------------------------------------------
	global.TGMX.IsEnabled = true;         // SYSTEM'S ACTIVE STATE BOOLEAN
	global.TGMX.TimeScale = 1.0;          // EFFECTS OVERALL SPEED OF HOW FAST SYSTEM PLAYS TWEENS/DELAYS
	global.TGMX.MinDeltaFPS = 10;         // THE LOWEST FRAMERATE BEFORE DELTA TWEENS WILL BEGIN TO LAG BEHIND (IDEALLY, KEEP BETWEEN 10-15)
	global.TGMX.UpdateInterval = 1.0;     // SETS HOW OFTEN (IN STEPS) SYSTEM WILL UPDATE (1 = DEFAULT, 2 = HALF SPEED, 0.5 = DOUBLE SPEED) DO NOT SET AS 0 OR BELOW!!
	global.TGMX.AutoCleanIterations = 10; // LIMITS, EACH STEP, NUMBER OF TWEENS PASSIVELY CHECKED BY MEMORY MANAGER (DEFAULT:10)
	global.TGMX.EasyUseDelta = false;	  // EASY TWEENS USE DELTA TIME?
	global.TGMX.GroupScales[? 0] = [1.0]; // SET DEFAULT GROUP 0 TO USE A DEFAULT TIME SCALE OF 1.0
	global.TGMX.TweensIncludeDeactivated = false; // WHETHER OR NOT TO INCLUDE TWEEN'S ASSOCIATED WITH DEACTIVATED TARGETS WHEN SELECTING TWEENS

	//-------------------------------------------------
	// INITIATE TWEEN INDEX SUPPLIER AND REFERENCE MAP
	//-------------------------------------------------
	global.TGMX.TweenIndex = 1;
	
	//-------------------------------
	// MACROS
	//-------------------------------
	#macro TWEEN_DEFAULT 1
	#macro TWEEN_NULL undefined
	// WE FIRST CHECK IF UNDEFINED TO SEE IF WE SHOULD GRAB VALUE FROM ARGUMENT SCRIPT RATHER THAN DIRECTLY
	#macro TWEEN_SELF (global.TGMX.tween_self ?? array_get(argument[3], TWEEN.ID))
	// HIDE SYNTAX WARNING
		global.TGMX.tween_self = 1; var _ = TWEEN_SELF;
		global.TGMX.tween_self = undefined;
	#macro TWEEN_CALLBACK_SELF global.TGMX.tween_callback_self
	TWEEN_CALLBACK_SELF = undefined;

	//---------------------------------------
	// DEFINE SYSTEM MACROS
	//---------------------------------------
	// TWEEN PLAY MODES
	#macro TWEEN_MODE_ONCE 0   // TWEEN PLAYS FROM START TO FINISH, ONCE
	#macro TWEEN_MODE_BOUNCE 1 // TWEEN PLAYS FROM START TO FINISH BEFORE PLAYING BACK TO START
	#macro TWEEN_MODE_PATROL 2 // TWEEN PLAYS BACK AND FORTH BETWEEN START AND FINISH -- CONTINUES UNTIL MANUALLY STOPPED
	#macro TWEEN_MODE_LOOP 3   // TWEEN LOOPS FROM START TO FINISH -- CONTINUES UNTIL MANUALLY STOPPED
	#macro TWEEN_MODE_REPEAT 4 // TWEEN USES FINISH POSITION AS A NEW RELATIVE STARTING POSITION -- CONTINUES UNTIL MANUALLY STOOPPED

	// TWEEN EVENT TYPES
	#macro TWEEN_EV_PLAY 0			// WHEN TWEEN STARTS TO PLAY
	#macro TWEEN_EV_FINISH 1		// WHEN TWEEN FINISHES PLAYING
	#macro TWEEN_EV_STOP 2			// WHEN TWEEN IS STOPPED MANUALLY
	#macro TWEEN_EV_PAUSE 3			// WHEN TWEEN IS PAUSED MANUALLY
	#macro TWEEN_EV_RESUME 4		// WHEN TWEEN IS RESUMED MANUALLY
	#macro TWEEN_EV_CONTINUE 5		// WHEN TWEEN BOUNCES, PATROLS, LOOPS, OR REPEATS
	#macro TWEEN_EV_REVERSE 6		// WHEN TWEEN IS REVERSED MANUALLY
	#macro TWEEN_EV_STOP_DELAY 7	// WHEN TWEEN IS STOPPED WHILE IT IS DELAYED
	#macro TWEEN_EV_PAUSE_DELAY 8	// WHEN TWEEN IS PAUSED WHILE DELAYED
	#macro TWEEN_EV_RESUME_DELAY 9	// WHEN TWEEN IS RESUMED WHILE DELAYED
	#macro TWEEN_EV_FINISH_DELAY 10	// WHEN TWEEN'S DELAY FINISHES -- CALLED JUST BEFORE TWEEN_EV_PLAY
	#macro TWEEN_EV_REST 11
	#macro TWEEN_EV_RESTING 12
	#macro TWEEN_EV_TOTAL_EVENTS 13

	// TWEEN USER PROPERTIES
	#macro TWEEN_USER_VALUE global.TGMX.user_value	 // TWEENED VALUE PASSED TO USER EVENT
	#macro TWEEN_USER_TARGET global.TGMX.user_target // TWEENED TARGET PASSED TO USER EVENT
	#macro TWEEN_USER_GET global.TGMX.tween_user_get // USED TO ALLOW 'GETTERS' FOR USER EVENT PROPERTIES
	#macro TWEEN_USER_DATA global.TGMX.user_data	 // OPTIONAL DATA PASSED TO USER EVENT PROPRETIES

	//-------------------------------
	// Declare Enums
	//-------------------------------
	// TWEEN DATA
	enum TWEEN
	{
		STATE,				// 0 -- THE FIRST INDEX NEEDS TO BE SOMETHING NOT USED BY SHORTHAND CODES!
		DURATION,			// 1
		DURATION_RAW,		// 2
		DELTA,				// 3
		SCALE,				// 4
		TIME,				// 5
		TARGET,				// 6
		EASE,				// 7
		PROPERTY_DATA,		// 8
		PROPERTY_DATA_RAW,	// 9
		GROUP,				// 10
		GROUP_SCALE,		// 11
		DIRECTION,			// 12
		EVENTS,				// 13
		DESTROY,			// 14
		MODE,				// 15
		DELAY,				// 16
		DELAY_START,		// 17
		ID,					// 18
		AMOUNT,				// 19
		CALLER,				// 20
		OTHER,				// 21
		REST,				// 22
		CONTINUE_COUNT,		// 23
		EASE_RAW,			// 24
		DATA_SIZE,
						
		CHANGE,
		START,
		DESTINATION,
		PROPERTY,
		RAW_START,
		RAW_DESTINATION,
	}					

	// TWEEN STATES
	enum TWEEN_STATE{DESTROYED=-4,STOPPED=-10,PAUSED=-11,DELAYED=-12};
	// TWEEN CALLBACK DATA
	enum TWEEN_CB{TWEEN,ENABLED,TARGET,SCRIPT,ARG};
	
	// INITIALISE EVENT MAPS FOR TweenIs*() SCRIPTS
	global.TGMX.EventMaps = array_create(TWEEN_EV_TOTAL_EVENTS);
	var i = -1;
	repeat(TWEEN_EV_TOTAL_EVENTS)
	{
		global.TGMX.EventMaps[++i] = ds_map_create();
	}

	//-----------------------------
	// TWEEN DATA LABEL INDEXING --> SOUNDS FANCIER THAN IT REALLY IS!
	//-----------------------------
	global.TGMX.TweenDataLabelMap = ds_map_create();
	global.TGMX.TweenDataLabelMap[? "target"] = TWEEN.TARGET;
	global.TGMX.TweenDataLabelMap[? "?"] = TWEEN.TARGET;
	global.TGMX.TweenDataLabelMap[? "time"] = TWEEN.TIME;
	global.TGMX.TweenDataLabelMap[? "="] = TWEEN.TIME;
	global.TGMX.TweenDataLabelMap[? "scale"] = TWEEN.SCALE;
	global.TGMX.TweenDataLabelMap[? "timescale"] = TWEEN.SCALE;
	global.TGMX.TweenDataLabelMap[? "*"] = TWEEN.SCALE;
	global.TGMX.TweenDataLabelMap[? "amount"] = TWEEN.AMOUNT;
	global.TGMX.TweenDataLabelMap[? "timeamount"] = TWEEN.AMOUNT;
	global.TGMX.TweenDataLabelMap[? "%"] = TWEEN.AMOUNT;
	global.TGMX.TweenDataLabelMap[? "ease"] = TWEEN.EASE;
	global.TGMX.TweenDataLabelMap[? "~"] = TWEEN.EASE;
	global.TGMX.TweenDataLabelMap[? "start"] = TWEEN.START;
	global.TGMX.TweenDataLabelMap[? "destination"] = TWEEN.DESTINATION;
	global.TGMX.TweenDataLabelMap[? "dest"] = TWEEN.DESTINATION;
	global.TGMX.TweenDataLabelMap[? "rawstart"] = TWEEN.RAW_START;
	global.TGMX.TweenDataLabelMap[? "rawdestination"] = TWEEN.RAW_DESTINATION;
	global.TGMX.TweenDataLabelMap[? "rawdest"] = TWEEN.RAW_DESTINATION;
	global.TGMX.TweenDataLabelMap[? "duration"] = TWEEN.DURATION;
	global.TGMX.TweenDataLabelMap[? "$"] = TWEEN.DURATION;
	global.TGMX.TweenDataLabelMap[? "dur"] = TWEEN.DURATION;
	global.TGMX.TweenDataLabelMap[? "rest"] = TWEEN.REST;
	global.TGMX.TweenDataLabelMap[? "|"] = TWEEN.REST;
	global.TGMX.TweenDataLabelMap[? "delay"] = TWEEN.DELAY;
	global.TGMX.TweenDataLabelMap[? "delaystart"] = TWEEN.DELAY_START;
	global.TGMX.TweenDataLabelMap[? "group"] = TWEEN.GROUP;
	global.TGMX.TweenDataLabelMap[? "&"] = TWEEN.GROUP;
	global.TGMX.TweenDataLabelMap[? "state"] = TWEEN.STATE;
	global.TGMX.TweenDataLabelMap[? "mode"] = TWEEN.MODE;
	global.TGMX.TweenDataLabelMap[? "#"] = TWEEN.MODE;
	global.TGMX.TweenDataLabelMap[? "delta"] = TWEEN.DELTA;
	global.TGMX.TweenDataLabelMap[? "^"] = TWEEN.DELTA;
	global.TGMX.TweenDataLabelMap[? "property"] = TWEEN.PROPERTY;
	global.TGMX.TweenDataLabelMap[? "properties"] = TWEEN.PROPERTY;
	global.TGMX.TweenDataLabelMap[? "prop"] = TWEEN.PROPERTY;
	global.TGMX.TweenDataLabelMap[? "continuecount"] = TWEEN.CONTINUE_COUNT;
	global.TGMX.TweenDataLabelMap[? "count"] = TWEEN.CONTINUE_COUNT;
	global.TGMX.TweenDataLabelMap[? "cc"] = TWEEN.CONTINUE_COUNT;
	global.TGMX.TweenDataLabelMap[? TWEEN.TARGET] = TWEEN.TARGET;
	global.TGMX.TweenDataLabelMap[? TWEEN.PROPERTY_DATA_RAW] = TWEEN.PROPERTY_DATA_RAW;
	global.TGMX.TweenDataLabelMap[? TWEEN.TIME] = TWEEN.TIME;
	global.TGMX.TweenDataLabelMap[? TWEEN.SCALE] = TWEEN.SCALE;
	global.TGMX.TweenDataLabelMap[? TWEEN.AMOUNT] = TWEEN.AMOUNT;
	global.TGMX.TweenDataLabelMap[? TWEEN.EASE] = TWEEN.EASE;
	global.TGMX.TweenDataLabelMap[? TWEEN.START] = TWEEN.START;
	global.TGMX.TweenDataLabelMap[? TWEEN.DESTINATION] = TWEEN.DESTINATION;
	global.TGMX.TweenDataLabelMap[? TWEEN.DURATION] = TWEEN.DURATION;
	global.TGMX.TweenDataLabelMap[? TWEEN.DELAY] = TWEEN.DELAY;
	global.TGMX.TweenDataLabelMap[? TWEEN.DELAY_START] = TWEEN.DELAY_START;
	global.TGMX.TweenDataLabelMap[? TWEEN.GROUP] = TWEEN.GROUP;
	global.TGMX.TweenDataLabelMap[? TWEEN.STATE] = TWEEN.STATE;
	global.TGMX.TweenDataLabelMap[? TWEEN.MODE] = TWEEN.MODE;
	global.TGMX.TweenDataLabelMap[? TWEEN.DELTA] = TWEEN.DELTA;

	//------------------------------------------------------------------------------------------------
	// SET SUPPORTED LABELS FOR TWEEN "TAGS".
	// THERE ARE MULTIPLE VALUES FOR EACH PROPERTY, ALLOWING FOR ALTERNATIVE AND SHORTHAND LABELS.
	// MODIFY OR ADD YOUR OWN LABELS AS DESIRED!!! :)
	//------------------------------------------------------------------------------------------------

	global.TGMX.ArgumentLabels = ds_map_create();
	var _ = global.TGMX.ArgumentLabels;

	// TWEEN CHAIN
	_[? ">>"] = 0;
	// CONTINUE COUNT
	_[? ">"] = TWEEN.CONTINUE_COUNT;
	_[? "-continuecount"] = TWEEN.CONTINUE_COUNT;
	_[? "-count"] = TWEEN.CONTINUE_COUNT;
	_[? "-cc"] = TWEEN.CONTINUE_COUNT;
	// TARGET
	_[? "-target"] = TWEEN.TARGET;
	_[? "?"] = TWEEN.TARGET;
	// EASE
	_[? "-ease"] = TWEEN.EASE;
	_[? "~"] = TWEEN.EASE;
	// MODE
	_[? "-mode"] = TWEEN.MODE;
	_[? "#"] = TWEEN.MODE;
	// DURATION
	_[? "-duration"] = TWEEN.DURATION;
	_[? "-dur"] = TWEEN.DURATION;
	_[? "$"] = TWEEN.DURATION;
	// DELTA (USE SECONDS?)
	_[? "-delta"] = TWEEN.DELTA;
	_[? "^"] = TWEEN.DELTA;
	// DELAY
	_[? "-delay"] = TWEEN.DELAY;
	_[? "+"] = TWEEN.DELAY;
	// REST
	_[? "-rest"] = TWEEN.REST;
	_[? "|"] = TWEEN.REST;
	// GROUP
	_[? "-group"] = TWEEN.GROUP;
	_[? "&"] = TWEEN.GROUP;
	// TIME
	_[? "-time"] = TWEEN.TIME;
	_[? "="] = TWEEN.TIME;
	// TIME AMOUNT / POSITION -- RELATIVE VALUE BETWEEN 0 AND 1
	_[? "-timeamount"] = TWEEN.AMOUNT;
	_[? "-amount"] = TWEEN.AMOUNT;
	_[? "%"] = TWEEN.AMOUNT;
	// TIME SCALE
	_[? "-timescale"] = TWEEN.SCALE;
	_[? "-scale"] = TWEEN.SCALE;
	_[? "*"] = TWEEN.SCALE;
	// AUTO-DESTROY
	_[? "-destroy"] = TWEEN.DESTROY;
	_[? "!"] = TWEEN.DESTROY;

	// ADD ARGUMENT LABELS TO THE LABEL MAP
	var _key = ds_map_find_first(_);
	repeat(ds_map_size(_))
	{
		global.TGMX.TweenDataLabelMap[? _key] = _[? _key];
		_key = ds_map_find_next(_, _key);
	}

	// THIS IS THE SAME MAP AS ABOVE... THIS IS NOT CLEAR AT A GLANCE!!!!
	// CALLBACK EVENTS
	_[? "@"] = TWEEN_EV_FINISH;
	_[? "@finish"] = TWEEN_EV_FINISH;
	_[? "@finished"] = TWEEN_EV_FINISH;
	_[? "@continue"] = TWEEN_EV_CONTINUE;
	_[? "@continued"] = TWEEN_EV_CONTINUE;
	_[? "@pause"] = TWEEN_EV_PAUSE;
	_[? "@paused"] = TWEEN_EV_PAUSE;
	_[? "@play"] = TWEEN_EV_PLAY;
	_[? "@played"] = TWEEN_EV_PLAY;
	_[? "@resume"] = TWEEN_EV_RESUME;
	_[? "@resumed"] = TWEEN_EV_RESUME;
	_[? "@stop"] = TWEEN_EV_STOP;
	_[? "@stopped"] = TWEEN_EV_STOP;
	_[? "@reverse"] = TWEEN_EV_REVERSE;
	_[? "@reversed"] = TWEEN_EV_REVERSE;
	_[? "@rest"] = TWEEN_EV_REST;
	_[? "@rested"] = TWEEN_EV_REST;
	_[? "@resting"] = TWEEN_EV_RESTING;
	_[? "@finishdelay"] = TWEEN_EV_FINISH_DELAY;
	_[? "@delayfinish"] = TWEEN_EV_FINISH_DELAY;
	_[? "@finisheddelay"] = TWEEN_EV_FINISH_DELAY;
	_[? "@delayfinished"] = TWEEN_EV_FINISH_DELAY;
	_[? "@pausedelay"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@delaypause"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@pauseddelay"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@delaypaused"] = TWEEN_EV_PAUSE_DELAY;
	_[? "@resumedelay"] = TWEEN_EV_RESUME_DELAY;
	_[? "@delayresume"] = TWEEN_EV_RESUME_DELAY;
	_[? "@resumeddelay"] = TWEEN_EV_RESUME_DELAY;
	_[? "@delayresumed"] = TWEEN_EV_RESUME_DELAY;
	_[? "@stopdelay"] = TWEEN_EV_STOP_DELAY;
	_[? "@delaystop"] = TWEEN_EV_STOP_DELAY;
	_[? "@stoppeddelay"] = TWEEN_EV_STOP_DELAY;
	_[? "@delaystopped"] = TWEEN_EV_STOP_DELAY;

	// CREATE A SHORTHAND LOOKUP TABLE FOR SHORTHAND SYMBOLS
	_ = array_create(128);
	_[33]  = TWEEN.DESTROY;			// "!"
	_[35]  = TWEEN.MODE;			// "#"
	_[36]  = TWEEN.DURATION;		// "$"
	_[37]  = TWEEN.AMOUNT;			// "%"
	_[38]  = TWEEN.GROUP;			// "&"
	_[42]  = TWEEN.SCALE;			// "*"
	_[43]  = TWEEN.DELAY;			// "+"
	_[45] = undefined;				// "-" THIS IS AN EXCEPTION! This is used to check for off-rail tweens -- !! DOCUMENT THIS OR CREATE A NEW TABLE !!
	_[61]  = TWEEN.TIME;			// "="
	_[62]  = TWEEN.CONTINUE_COUNT;	// ">"
	_[94]  = TWEEN.DELTA;			// "^"
	_[124] = TWEEN.REST;			// "|"
	_[126] = TWEEN.EASE;			// "~"
	global.TGMX.ShorthandTable = _;

	//====================//
	// MODE "SHORT CODES" //
	//====================//
	global.TGMX.ShortCodesMode = ds_map_create();
	_ = global.TGMX.ShortCodesMode;

	// MODE "SHORT CODES"
	_[? "#0"] = TWEEN_MODE_ONCE;		_[? "0"] = TWEEN_MODE_ONCE;
	_[? "#o"] = TWEEN_MODE_ONCE;		_[? "o"] = TWEEN_MODE_ONCE;
	_[? "#once"] = TWEEN_MODE_ONCE;		_[? "once"] = TWEEN_MODE_ONCE;
	
	_[? "#1"] = TWEEN_MODE_BOUNCE;		_[? "1"] = TWEEN_MODE_BOUNCE;
	_[? "#b"] = TWEEN_MODE_BOUNCE;		_[? "b"] = TWEEN_MODE_BOUNCE;
	_[? "#bounce"] = TWEEN_MODE_BOUNCE;	_[? "bounce"] = TWEEN_MODE_BOUNCE;
	
	_[? "#2"] = TWEEN_MODE_PATROL;		_[? "2"] = TWEEN_MODE_PATROL;
	_[? "#p"] = TWEEN_MODE_PATROL;		_[? "p"] = TWEEN_MODE_PATROL;
	_[? "#patrol"] = TWEEN_MODE_PATROL; _[? "patrol"] = TWEEN_MODE_PATROL;
	
	_[? "#3"] = TWEEN_MODE_LOOP;		_[? "3"] = TWEEN_MODE_LOOP;
	_[? "#l"] = TWEEN_MODE_LOOP;		_[? "l"] = TWEEN_MODE_LOOP;
	_[? "#loop"] = TWEEN_MODE_LOOP;		_[? "loop"] = TWEEN_MODE_LOOP;
	
	_[? "#4"] = TWEEN_MODE_REPEAT;		_[? "4"] = TWEEN_MODE_REPEAT;
	_[? "#r"] = TWEEN_MODE_REPEAT;		_[? "r"] = TWEEN_MODE_REPEAT;
	_[? "#repeat"] = TWEEN_MODE_REPEAT;	_[? "repeat"] = TWEEN_MODE_REPEAT;
	
	//---------------------------
	// SET DEFAULT TWEEN
	//---------------------------
	global.TGMX.TweenDefault[TWEEN.ID] = TWEEN_DEFAULT;
	global.TGMX.TweenDefault[TWEEN.TARGET] = noone;
	global.TGMX.TweenDefault[TWEEN.EASE] = "linear";
	global.TGMX.TweenDefault[TWEEN.TIME] = 0;
	global.TGMX.TweenDefault[TWEEN.DURATION] = 1;
	global.TGMX.TweenDefault[TWEEN.PROPERTY_DATA_RAW] = -1;
	global.TGMX.TweenDefault[TWEEN.STATE] = TWEEN_STATE.STOPPED;
	global.TGMX.TweenDefault[TWEEN.SCALE] = 1;
	global.TGMX.TweenDefault[TWEEN.DELTA] = false;
	global.TGMX.TweenDefault[TWEEN.GROUP] = 0;
	global.TGMX.TweenDefault[TWEEN.GROUP_SCALE] = global.TGMX.GroupScales[? 0];
	global.TGMX.TweenDefault[TWEEN.EVENTS] = -1;
	global.TGMX.TweenDefault[TWEEN.DESTROY] = 1;
	global.TGMX.TweenDefault[TWEEN.DIRECTION] = 1;
	global.TGMX.TweenDefault[TWEEN.MODE] = TWEEN_MODE_ONCE;
	global.TGMX.TweenDefault[TWEEN.PROPERTY_DATA] = 0;
	global.TGMX.TweenDefault[TWEEN.DELAY] = 0;
	global.TGMX.TweenDefault[TWEEN.DELAY_START] = 0;
	global.TGMX.TweenDefault[TWEEN.AMOUNT] = 0;
	global.TGMX.TweenDefault[TWEEN.CALLER] = noone;
	global.TGMX.TweenDefault[TWEEN.OTHER] = noone;
	global.TGMX.TweenDefault[TWEEN.REST] = 0;
	global.TGMX.TweenDefault[TWEEN.CONTINUE_COUNT] = -1;
	global.TGMX.TweenDefault[TWEEN.EASE_RAW] = 0;
	
	//-------------------------------------------------
	// ASSIGN DEFAULT TWEEN AS [1] IN INDEX MAP
	//-------------------------------------------------
	global.TGMX.TweenIndexMap[? 1] = global.TGMX.TweenDefault;
	//---------------------------------------------------
	// ASSIGN [all] AS SHORTCUT FOR AFFECTING ALL TWEENS
	//---------------------------------------------------
	global.TGMX.TweenIndexMap[? all] = {target: all}; 
	
	return 1;
} 


/// @ignore
function TGMX_Cleanup()
{
	/// @function TGMX_Cleanup()
	/// @description TGMX ADMIN: Clean up system
	
	if (global.TGMX.SharedTweener != noone)
	{		
		// REMOVE SELF AS SHARED TWEENER SINGLETON
	    global.TGMX.SharedTweener = noone;
	    // DESTROY TWEENS AND DELAYS FOR PERSISTENT ROOMS
	    TweenSystemClearRoom(all);

		// CLEAR EVENT MAPS
		var i = -1;
		repeat(TWEEN_EV_TOTAL_EVENTS)
		{
			ds_map_clear(global.TGMX.EventMaps[++i]);
		}

		//---------------------------------------------
		// DESTROY REMAINING TWEENS
		//---------------------------------------------
		var _tweens = global.TGMX.tweens;
		var _tIndex = -1;
		repeat(ds_list_size(_tweens))
		{   
		    var _t = _tweens[| ++_tIndex];             // GET TWEEN AND INCREMENT ITERATOR
		    _t[@ TWEEN.STATE] = TWEEN_STATE.DESTROYED; // SET STATE AS DESTROYED
		    _t[@ TWEEN.ID] = undefined;                // NULLIFY SELF REFERENCE
    
		    // DESTROY TRWEEN EVENTS IF EVENTS MAP EXISTS
		    if (_t[TWEEN.EVENTS] != -1)
		    {
				ds_map_destroy(_t[TWEEN.EVENTS]);
		    }
		}

		//---------------------------------------
		// DESTROY DATA STRUCTURES
		//---------------------------------------
		ds_list_destroy(global.TGMX.tweens);
		ds_list_destroy(global.TGMX.delayedTweens);
		ds_map_destroy(global.TGMX.pRoomTweens);
		ds_map_destroy(global.TGMX.pRoomDelays);
		ds_priority_destroy(global.TGMX.eventCleaner);
		ds_queue_destroy(global.TGMX.stateChanger);
		
		//---------------------------------------
		// CLEAR DATA STRUCTURES
		//---------------------------------------
	    ds_map_clear(global.TGMX.TweenIndexMap);
		
		// PUT BACK DATA STRUCTURE DEFAULTS
		//-------------------------------------------------
		// ASSIGN DEFAULT TWEEN AS [1] IN INDEX MAP
		//-------------------------------------------------
		global.TGMX.TweenIndexMap[? 1] = global.TGMX.TweenDefault;
		//---------------------------------------------------
		// ASSIGN [all] AS SHORTCUT FOR AFFECTING ALL TWEENS
		//---------------------------------------------------
		global.TGMX.TweenIndexMap[? all] = {target: all};	 
	}
}

/// @ignore
function SharedTweener() 
{	
	/// @function SharedTweener()
	/// @description Manages Shared Tweener creation/retrieval
	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	
	// RETURN TWEENER IF IT ALREADY EXISTS
	if (instance_exists(global.TGMX.SharedTweener))
	{
		return global.TGMX.SharedTweener;
	}
	
	// ATTEMPT TO REACTIVATE DEACTIVATED TWEENER
	instance_activate_object(global.TGMX.SharedTweener);
	
	// RETURN TWEENER IF IT NOW EXISTS
	if (instance_exists(global.TGMX.SharedTweener))
	{
		return global.TGMX.SharedTweener;	
	}
	
	// CREATE A NEW TWEENER
	return instance_create_depth(0,0,0,o_SharedTweener);
}
	
/// @ignore
function TGMX_FetchTween(_tID)
{
	/// @function TGMX_FetchTween(tween_id)
	/// @description TGMX ADMIN: Retrieves raw tween array from tween id
	/// @param tween_id
	
	// MAKE SURE TWEENER HAS BEEN CREATED AT LEAST ONCE
	static _ = TGMX_Begin();
	
	if (is_array(_tID))
	{
		return _tID;
	}

	if (is_real(_tID))
	{
		// CHECK FOR TWEEN IN TWEEN INDEX MAP
		if (ds_map_exists(global.TGMX.TweenIndexMap, _tID))
		{
		    return global.TGMX.TweenIndexMap[? _tID];
		}
		
		// TWEEN OFFSECT SELECT
		if (_tID != undefined && _tID <= 0)
		{
			return global.TGMX.TweenIndexMap[? global.TGMX.TweenIndex-_tID];	
		}
		
		return undefined;
	}
	
	// ASSUME 'self' IS PASSED FOR A STRUCT
	if (is_struct(_tID)) 
	{
		return _tID == self ? {target: _tID} : _tID;
	}
	
	// ASSUME "self" IS PASSED FOR AN INSTANCE
	if (_tID != undefined)
	{
		return { target: _tID.id };
	}
	
	return undefined;
}

/// @ignore
function TGMX_TargetExists(_target) 
{
	/// @function TGMX_TargetExists(target)
	/// @description TGMX ADMIN: Checks to see if a tween's target is still valid
	/// @param target Instance or struct id/reference
	/// @return bool
	
	if (is_real(_target))
	{
		if (global.TGMX.TweensIncludeDeactivated)
		{		
		    if (instance_exists(_target))
			{
		        return true;
		    }
    
			instance_activate_object(_target);
    
		    if (instance_exists(_target))
			{
		        instance_deactivate_object(_target);
		        return true;
		    }
	
		    return false;
		}
		
		return instance_exists(_target);
	}

	if (_target != undefined)
	{
		return weak_ref_alive(_target);	
	}
	
	return false;
}

/// @ignore
function TGMX_StringStrip(_string, _offset=0) 
{
	/// @function TGMX_StringStrip(string, [offset])
	/// @description Lowers strings and removes underscores -- uses cache
	/// @param string
	/// @param [offset]
	
	// REFERENCE GLOBAL STRING CACHE
	static cache = global.TGMX.Cache;
	
	// CHECK CACHE FOR EXISTING LOWERED STRING
	if (ds_map_exists(cache, _string))
	{
		return cache[? _string];
	}
	
	// STORE ORIGINAL STRING
	var _string_og = _string;
	
	// REMOVE UNDERSCORES
	_string = string_replace_all(_string, "_", "");
	
	// CONVERT STRING TO LOWERCASE
	repeat(string_length(_string)-_offset)
	{
		var _byte = string_byte_at(_string, ++_offset);
		if (_byte <= 90 && _byte >= 65)
		{
			_string = string_set_byte_at(_string, _offset, _byte+32);
		}
	}

	// STORE NEW STRING INTO CACHE
	cache[? _string_og] = _string;
	// RETURN NEW LOWER CASE STRING
	return _string;
}

/// @ignore
function TGMX_Tween(_script, _args, _tID)
{
	/// @function TGMX_Tween(script, args, [tween_id])
	/// @description TGMX ADMIN: Base function for creating and playing tweens
	/// @param script 
	/// @param args 
	/// @param [tween_id]
	
	// MAKE SURE GLOBAL SYSTEM IS INITIALIZED
	static _ = TGMX_Begin();
	
	static STR_AT = "@"; // CACHE STRING POINTER TO IMPROVE PERFORMANCE
	static TGMX_Cache = global.TGMX.Cache;
	static TGMX_ArgumentLabels = global.TGMX.ArgumentLabels;
	
	var _sharedTweener = SharedTweener(); // MAKE SURE WE HAVE A SHARED TWEENER SINGLETON
	
	var TGMX = global.TGMX;
	var _doStart = true;
	var _qCallbacks = undefined;			// RESERVED FOR A QUEUE HOLDING CALLBACK DATA
	var _paramCount = array_length(_args)-1; // NUMBER OF PARAMTERRS SUPPLIED
	
	var _t, _pData;
	var i = -1; // THE MAIN LOOP ITERATOR... WILL BE SET BELOW BASED UPON WHERE WE NEED TO START WITHIN PASSED ARGUMENTS
	
	switch(_script)
	{
	case TweenFire:
		_tID = ++TGMX.TweenIndex;												// GET NEW UNIQUE TWEEN ID
		_pData = [];															// CREATE ARRAY TO HOLD PROPERTY DATA
		_t = array_create(TWEEN.DATA_SIZE);										// CREATE NEW TWEEN ARRAY
		array_copy(_t, 0, TGMX.TweenDefault, 0, TWEEN.DATA_SIZE);				// COPY DEFAULT VALUES INTO TWEEN ARRAY
		_t[TWEEN.ID] = _tID;													// NEW TWEEN CREATED WITH UNIQUE ID
		_t[TWEEN.CALLER] = is_struct(self) ? weak_ref_create(self) : id;		// STRUCT OR INSTANCE CALLING THE SCRIPT
		_t[TWEEN.OTHER] = is_struct(other) ? weak_ref_create(other) : other.id; // SET 'other' CALLING ENVIRONMENT
		_t[TWEEN.DESTROY] = true;												// MAKE PERSISTENT?
		
		// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
		if (_args[0] == undefined) 
		{	// SET OUR KNOWN VALUES
			_t[TWEEN.TARGET] = _args[1]; _t[TWEEN.EASE] = _args[2]; _t[TWEEN.MODE] = _args[3]; _t[TWEEN.DELTA] = _args[4]; _t[TWEEN.DELAY] = _args[5]; _t[TWEEN.DURATION] = _args[6];
			i = 6;
		}
		else
		{
			_t[TWEEN.TARGET] = _t[TWEEN.CALLER]; // SET DEFAULT TARGET TO CALLER ENVIRONMENT
		}
		
		TGMX.TweenIndexMap[? _tID] = _t;		// ASSOCIATE TWEEN WITH GLOBAL ID
		ds_list_add(_sharedTweener.tweens, _t);	// ADD TWEEN TO GLOBAL TWEENS LIST
	break;
	
	case TweenCreate:
		_tID = ++TGMX.TweenIndex;												// GET NEW UNIQUE TWEEN ID
		_pData = [];
		_t = array_create(TWEEN.DATA_SIZE);										// CREATE NEW TWEEN ARRAY
		array_copy(_t, 0, TGMX.TweenDefault, 0, TWEEN.DATA_SIZE);				// COPY DEFAULT VALUES INTO TWEEN ARRAY
		_t[TWEEN.ID] = _tID;													// NEW TWEEN CREATED WITH UNIQUE ID
		_t[TWEEN.CALLER] = is_struct(self) ? weak_ref_create(self) : id;		// STRUCT OR INSTANCE CALLING THE SCRIPT
		_t[TWEEN.OTHER] = is_struct(other) ? weak_ref_create(other) : other.id; // SET 'other' CALLING ENVIRONMENT
		_t[TWEEN.DESTROY] = false;												// MAKE PERSISTENT

		// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
		if (_args[0] == undefined) 
		{	// SET OUR KNOWN VALUES
			if (_paramCount == 1)
			{
				// TODO: MIGHT BE ABLE TO EXIT OUT EARLY HERE!
				_t[TWEEN.TARGET] = _args[1];	
				i = 1;
			}
			else
			{
				_t[TWEEN.TARGET] = _args[1]; _t[TWEEN.EASE] = _args[2]; _t[TWEEN.MODE] = _args[3]; _t[TWEEN.DELTA] = _args[4]; _t[TWEEN.DELAY] = _args[5]; _t[TWEEN.DURATION] = _args[6];
				i = 6;
			}
		}
		
		TGMX.TweenIndexMap[? _tID] = _t;		// ASSOCIATE TWEEN WITH GLOBAL ID
		ds_list_add(_sharedTweener.tweens, _t);	// ADD TWEEN TO GLOBAL TWEENS LIST
	break;
	
	case TweenPlay:
		if (is_real(_tID))
		{ 
			_tID = (_tID > 0) ? _tID : TGMX.TweenIndexMap[? TGMX.TweenIndex-_tID];
		}
		
		if (!TweenExists(_tID)) { return 0; }
		
		_t = TGMX_FetchTween(_tID);  // FETCH RAW TWEEN DATA -- TODO: THIS COULD BE MOVED INTO THE IF/ELSE ABOVE IF NOT ALREADY AN ARRAY
		_pData = _t[TWEEN.PROPERTY_DATA_RAW]; // CACHE EXISTING VARIABLE DATA LIST
		_t[@ TWEEN.DIRECTION] = 1;
		_t[@ TWEEN.SCALE] = abs(_t[TWEEN.SCALE]);
		_t[@ TWEEN.TIME] = 0;
		
		if (_paramCount > 0)
		{	//^ IF NEW ARGUMENTS ARE SUPPLIED
			_pData = [];
			_t[@ TWEEN.AMOUNT] = 0;
			_t[@ TWEEN.CALLER] = is_struct(self) ? weak_ref_create(self) : id; // STRUCT OR INSTANCE CALLING THE SCRIPT TODO
			
			// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
			if (_args[0] == undefined) 
			{	// SET OUR KNOWN VALUES
				_t[@ TWEEN.EASE] = _args[1]; _t[@ TWEEN.MODE] = _args[2]; _t[@ TWEEN.DELTA] = _args[3]; _t[@ TWEEN.DELAY] = _args[4]; _t[@ TWEEN.DURATION] = _args[5];
				i = 5;
			}
		}
	break;
	
	case TweenDefine:
		_tID = (_tID > 0) ? _tID : TGMX.TweenIndexMap[? TGMX.TweenIndex-_tID]; // CACHE TWEEN ID -- CHECK FOR "LAZY" TWEEN IDS

		if (!TweenExists(_tID)) { return 0; }
		
		_t = TGMX_FetchTween(_tID);  // FETCH RAW TWEEN DATA
		_pData = []; // SET NEW PROPRETY DATA ARRAY
		_t[@ TWEEN.CALLER] = is_struct(self) ? weak_ref_create(self) : id; // STRUCT OR INSTANCE CALLING THE SCRIPT
		
		// WE HAVE AN "ON-RAIL" TWEEN -- WE CAN APPLY THE VALUES WE KNOW WE HAVE
		if (_args[0] == undefined) 
		{	// SET OUR KNOWN VALUES
			_t[@ TWEEN.EASE] = _args[1]; _t[@ TWEEN.MODE] = _args[2]; _t[@ TWEEN.DELTA] = _args[3]; _t[@ TWEEN.DELAY] = _args[4]; _t[@ TWEEN.DURATION] = _args[5];
			i = 5;
		}
	break;
	}

	// LOOP THROUGH AND PROCESS SCRIPT PARAMETERS
	while(i < _paramCount)
	{		
		// GET NEXT TAG
		i += 1;
		var _tag = _args[i]; 
	
		//-------------------
		// ADVANCED PROPERTY
		if (is_array(_tag)) 
		{
			var _argCount = array_length(_tag);
			var _command = _tag[0];
			var _toFrom = 58; // ":" DEFAULT
			var _firstArg = _argCount > 1 ? _tag[1] : 0;

			if (_command == TPTarget) // TGMX_TODO: SEE IF THIS CAN BE MOVED INTO TARGET SETTER FUNCTION
			{	
				_firstArg = _tag[2];
				_tag[@ 2] = _tag[1];
				var _lastByte = string_byte_at(_firstArg, string_length(_firstArg));
			
				//if (">" or "<" or ":")
				if (_lastByte <= 62 && _lastByte >= 58)
				{	
					_toFrom = _lastByte;
					_firstArg = string_delete(_firstArg, string_length(_firstArg), 1);
				}
			}
			else
			if (is_string(_firstArg))
			{
				_firstArg = _argCount >= 2 ? _tag[1] : undefined;
				
				var _lastByte = string_byte_at(_firstArg, string_length(_firstArg));
			
				//if (">" or "<" or ":")
				if (_lastByte <= 62 && _lastByte >= 58)
				{	
					_toFrom = _lastByte;
					_firstArg = string_delete(_firstArg, string_length(_firstArg), 1);
				}

				// TODO: THIS MIGHT NEED TO BE UDPATED FOR PROPER TARGET HANDLING
				if (_command == TPUser)
				{
					_firstArg = TGMX_Variable_Get(self, _firstArg, self, other);
				}
			}
				
			switch(_argCount)
			{
			case 1: _tag = [_command, undefined]; break;
			case 2: _tag = ds_map_exists(TGMX.PropertyNormals, _command) ? [_command, [_firstArg, 0, 0]] : [_command, _firstArg]; break;
			default:
				var _xargs = array_create(_argCount-1);
				var _iArg = 0;
				_xargs[0] = _firstArg;
				
				repeat(_argCount-2)
				{
					_iArg += 1;
					_xargs[_iArg] = _tag[_iArg+1];
				}
				
				_tag = [_command, _xargs];
			}
			
			switch(_toFrom)
			{
			case 58: // : DEFAULT
				i += 2; 
				array_push(_pData, _tag, _args[i-1], _args[i]);
			break;
			case 62: // > TO
				i += 1;
				array_push(_pData, _tag, STR_AT, _args[i]);
			break; 
			case 60: // < FROM
				i += 1;
				array_push(_pData, _tag, _args[i], STR_AT);
			break;
			}
		}
		else //------------------
		{	 // REGULAR PROPERTY
			var _tag_flat = TGMX_Cache[? _tag] ?? TGMX_StringStrip(_tag); // Get a "flat" version of the tag
			var _argLabel = TGMX_ArgumentLabels[? _tag_flat]; // LOOKUP ENUMS (TWEEN AND EVENT) -- OTHERWISE UNDEFINED

			// TWEEN.ENUM TYPE
			if (is_numeric(_argLabel)) 
			{
				switch(string_byte_at(_tag, 1))
				{						
				case 64: // "@" Event Callback -- This makes sure that we use the right assigned target before actually adding the callbacks later in this function
					if (_qCallbacks == undefined) _qCallbacks = ds_queue_create();
					i += 1;
					ds_queue_enqueue(_qCallbacks, _argLabel, _args[i]);
				break;
				
				case 62: // ">" Count OR ">>" Chain
					if (string_length(_tag) == 1) // Check for ">count" first
					{
						i += 1;
						_t[@ _argLabel] = _args[i];
						break;
					}
					
					// Else we have a chain
					_doStart = false; // Tell system not to play the tween right away
				
					if (i < _paramCount && is_real(_args[i+1])) // ADD PLAY CHAIN TO SELECTED TWEEN
					{	
						i += 1;
						TweenAddCallback(_args[i] ? _args[i] : _args[i]+TGMX.TweenIndex, TWEEN_EV_FINISH, _sharedTweener, TweenPlay, _tID); // Use index based on whether or not greater than 0 ... -1
					}
					else // < ADD PLAY CHAIN TO PREVIOUSLY CREATED TWEEN
					{	
						TweenAddCallback(TGMX.TweenIndex-1, TWEEN_EV_FINISH, _sharedTweener, TweenPlay, _tID);
					}
				break;
				
				default: // SET TWEEN DATA TYPE e.g. TweenFire(..., "-mode", "patrol", "$", 100...)
					i += 1;
					if (is_string(_args[i])) { _t[@ _argLabel] = TGMX_Cache[? _args[i]] ?? TGMX_StringStrip(_args[i]); }
					else					 { _t[@ _argLabel] = _args[i]; }
				break;
				} 
			}
			else //-----------------------------------------
			{	 // SHORTHAND SETTER *OR* VARIABLE PROPERTY
				var _shortIndex = TGMX.ShorthandTable[string_byte_at(_tag, 1)];
			
				switch(_shortIndex)
				{
				case 0: // DEAL WITH VARIABLE PROPERTY "x", "x>", "x<", "x:"
					switch(string_byte_at(_tag, string_length(_tag)))
					{	
					case 62: // // > TO
						i += 1;
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), STR_AT, _args[i]); // TODO: ADD A STRING CACHE
					break;
					case 60: // < FROM
						i += 1;
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), _args[i], STR_AT);
					break;
					case 58: // : TO FROM
						i += 2; 
						array_push(_pData, string_delete(_tag, string_length(_tag), 1), _args[i-1], _args[i]); 
					break;
					default: // TO FROM 
						i += 2;
						array_push(_pData, _tag, _args[i-1], _args[i]);
					}
				break;
				case TWEEN.EASE: _t[@ TWEEN.EASE] = string_delete(_tag, 1, 1); break; // SET EASE ~
				case TWEEN.MODE: _t[@ TWEEN.MODE] = string_delete(_tag, 1, 1); break; // SET MODE #
				default: _t[@ _shortIndex] = real(string_delete(_tag, 1, 1)); break;  // SET OTHER DATA TYPE !1, $60, %0.5, ^1, &5, *0.5, |30
				}
			}
		}
	}

	
	// ASSIGN GROUP SCALE
	_t[@ TWEEN.GROUP_SCALE] = TGMX.GroupScales[? _t[TWEEN.GROUP]];
	
	// CREATE NEW GROUP SCALE IF NOT SET
	if (_t[TWEEN.GROUP_SCALE] == undefined)
	{
		_t[@ TWEEN.GROUP_SCALE] = [1.0];
		TGMX.GroupScales[? _t[TWEEN.GROUP]] = _t[TWEEN.GROUP_SCALE];
	}
	
	// ASSIGN NEWLY CREATED VARIABLE DATA LIST
	_t[@ TWEEN.PROPERTY_DATA_RAW] = _pData;
	
	// FINALIZE USED TARGET -- CREATE WEAK REFERENCE IF STRUCT AND GET ID IF INSTANCE
	_t[@ TWEEN.TARGET] = is_struct(_t[TWEEN.TARGET]) ? weak_ref_create(_t[TWEEN.TARGET]) : _t[TWEEN.TARGET].id;

	// FINALIZE USED EASE TYPE
	if (is_string(_t[TWEEN.EASE])) // CONVERT EASE TYPE IF A STRING
	{
		_t[@ TWEEN.EASE] = TGMX.ShortCodesEase[? TGMX_Cache[? _t[TWEEN.EASE]] ?? TGMX_StringStrip(_t[TWEEN.EASE])];
		
		// THIS IS A TEMPORARY FIX FOR HTML5 ISSUE
		//if (!is_struct(_t[TWEEN.EASE])) { _t[@ TWEEN.EASE] = method(undefined, method_get_index(_t[TWEEN.EASE])); }
	}
	else
	if (is_real(_t[TWEEN.EASE])) // CONVERT REAL TYPE
	{
							// IS CURVE ID		   // GET CURVE CHANNEL						  // CONVERT FUNCTION ID TO METHOD
		_t[@ TWEEN.EASE] = _t[TWEEN.EASE] < 100000 ? animcurve_get_channel(_t[TWEEN.EASE], 0) : method(undefined, _t[TWEEN.EASE]);
	}
	else
	if (is_array(_t[TWEEN.EASE])) // HANDLE MULTI-EASE-TYPE TWEEN
	{	
		if (is_string(_t[TWEEN.EASE][0])) // CONVERT EASE STRINGS INTO EXISTING EASE METHODS
		{
			_t[TWEEN.EASE][@ 0] = TGMX.ShortCodesEase[? TGMX_StringStrip(_t[TWEEN.EASE][0])];
		}
		else
		if (is_real(_t[TWEEN.EASE][0]))	// CONVERT FUNCTION ID OR ANIMATION CURVE ID
		{								// IS CURVE ID		   // GET CURVE CHANNEL						  // CONVERT FUNCTION ID TO METHOD
			_t[@ TWEEN.EASE][@ 0] = _t[TWEEN.EASE][0] < 100000 ? animcurve_get_channel(_t[TWEEN.EASE][0], 0) : method(undefined, _t[TWEEN.EASE][0]);
		}
		
		if (is_string(_t[TWEEN.EASE][1]))
		{
			_t[TWEEN.EASE][@ 1] = TGMX.ShortCodesEase[? TGMX_StringStrip(_t[TWEEN.EASE][1])];
		}
		else
		if (is_real(_t[TWEEN.EASE][1]))
		{							// IS CURVE ID		       // GET CURVE CHANNEL						     // CONVERT FUNCTION ID TO METHOD
			_t[@ TWEEN.EASE][@ 1] = _t[TWEEN.EASE][1] < 100000 ? animcurve_get_channel(_t[TWEEN.EASE][1], 0) : method(undefined, _t[TWEEN.EASE][1]);
		}
		
		// STORE RAW TWEENS FOR SWAPPING
		_t[@ TWEEN.EASE_RAW] = _t[TWEEN.EASE];
		// SET ACTIVE EASE FUNCTION
		_t[@ TWEEN.EASE] = _t[TWEEN.EASE][0];
	}
	
	// CONVERT MODE TYPE IF A STRING
	if (is_string(_t[TWEEN.MODE]))
	{
		_t[@ TWEEN.MODE] = TGMX.ShortCodesMode[? _t[TWEEN.MODE]];
	}
	else // TWEEN MODE WITH CONTINUE COUNT
	if (is_array(_t[TWEEN.MODE]))
	{
		_t[@ TWEEN.CONTINUE_COUNT] = _t[TWEEN.MODE][1];
		_t[@ TWEEN.MODE] = is_real(_t[TWEEN.MODE][0]) ? _t[TWEEN.MODE][0] : TGMX.ShortCodesMode[? TGMX_StringStrip(_t[TWEEN.MODE][0])];
	}

	// DURATION SWAPPING
	if (is_array(_t[TWEEN.DURATION]) && array_length(_t[TWEEN.DURATION]) == 2)
	{
		if (_t[TWEEN.DURATION][0] <= 0) { _t[TWEEN.DURATION][@ 0] = 0.0000001; }
		if (_t[TWEEN.DURATION][1] <= 0) { _t[TWEEN.DURATION][@ 1] = 0.0000001; }
		_t[@ TWEEN.DURATION_RAW] = _t[TWEEN.DURATION];
		_t[@ TWEEN.DURATION] = _t[TWEEN.DURATION][0];
	}
	
	// DELAY AND RESTS
	if (is_array(_t[TWEEN.DELAY]))
	{
		_t[@ TWEEN.REST] = (array_length(_t[TWEEN.DELAY]) == 2) ? _t[TWEEN.DELAY][1] : [_t[TWEEN.DELAY][1], _t[TWEEN.DELAY][2]];
		_t[@ TWEEN.DELAY] = _t[TWEEN.DELAY][0];
	}
	
	// TRACK DELAY START
	_t[@ TWEEN.DELAY_START] = _t[TWEEN.DELAY];

	// HANDLE QUEUED CALLBACK EVENTS
	if (_qCallbacks != undefined)
	{
		repeat(ds_queue_size(_qCallbacks) div 2)
		{
			var _event = ds_queue_dequeue(_qCallbacks);
			var _cbData = ds_queue_dequeue(_qCallbacks);
			
			if (!is_array(_cbData)) // REGULAR CALLBACK WITH ASSUMED TARGET BELONGING TO TWEEN
			{
				TweenAddCallback(_tID, _event, _t[TWEEN.TARGET], _cbData);
			}
			else // HANDLE ADVANCED CALLBACK
			{
				var _cbDataTarget = _cbData[0];
				
				// First argument is a method or function id -- _cbData[0] is first argument in array
				if (is_method(_cbDataTarget) || is_real(_cbDataTarget))
				{
					var _cArgs = [_tID, _event, _t[TWEEN.TARGET]];
					array_copy(_cArgs, 3, _cbData, 0, array_length(_cbData));
				}
				else // Undefined -- use original method environment
				if (_cbDataTarget == undefined) 
				{
					var _cArgs = [_tID, _event, method_get_self(_cbData[1])];
					array_copy(_cArgs, 3, _cbData, 1, array_length(_cbData)-1);
				}
				else // Explicit target using {target: some_target}
				if (is_struct(_cbDataTarget))
				{	
					var _cArgs = array_create(array_length(_cbData) + 2);
					_cArgs[0] = _tID;
					_cArgs[1] = _event;
					
					if (_cbDataTarget == self) {
						_cArgs[2] = self;
					}
					else
					if (_cbDataTarget == other) {
						_cArgs[2] = other;
					}
					else {
						_cArgs[2] = _cbData[0].target;
					}
					
					array_copy(_cArgs, 3, _cbData, 1, array_length(_cbData)-1);
				}
				else // INSTANCE self | other TARGET
				{
					var _cArgs = [_tID, _event, _cbDataTarget.id]; // TODO: IS THIS NOT SUPPORTING STRUCT TARGET ??
					array_copy(_cArgs, 3, _cbData, 1, array_length(_cbData)-1);
				}
				
				// Execute TweenAddCallback() with defined arguments above
				script_execute_ext(TweenAddCallback, _cArgs);	
			}
		}

		// Destroy temp callback queue
		ds_queue_destroy(_qCallbacks);	
	}

	// Return early for specific calls
	switch(_script)
	{
		case TweenCreate: return _tID;
		case TweenDefine: return TGMX_TweenPreprocess(_t);
	}

	// CHECK FOR DELAYED TWEEN
	if (_t[TWEEN.DELAY] != 0)
	{   
		if (_doStart) { _t[@ TWEEN.STATE] = TWEEN_STATE.DELAYED; } // Set tween as waiting 
	
		// Put to starting tween position right away if a negative delay is given ( NOTE: This is a hidden feature! )
		if (_t[TWEEN.DELAY] < 0)
		{
			_t[@ TWEEN.DELAY] = abs(_t[TWEEN.DELAY]);
			TGMX_TweenPreprocess(_t);
			TGMX_TweenProcess(_t, _t[TWEEN.TIME], _t[TWEEN.PROPERTY_DATA], is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref);
		}
	
		ds_list_add(_sharedTweener.delayedTweens, _t); // ADD TWEEN TO DELAY LIST
		
		// RETURN WITH TWEEN ID
		return _tID;
	}
	
	// CHECK IF WE ARE TO START THE TWEEN RIGHT AWAY
	if (_doStart)
	{		
		// 1) MARK FOR CHANGE STATE LATER
		// 2) ELSE SET TWEEN AS ACTIVE
		if (_sharedTweener.inUpdateLoop) { ds_queue_enqueue(_sharedTweener.stateChanger, _t, _t[TWEEN.TARGET]); }
		else							 { _t[@ TWEEN.STATE] = _t[TWEEN.TARGET]; } 
		// Pre-process tween data
		TGMX_TweenPreprocess(_t);
		// Process tween
		TGMX_TweenProcess(_t, _t[TWEEN.TIME], _t[TWEEN.PROPERTY_DATA],  is_real(_t[TWEEN.TARGET]) ? _t[TWEEN.TARGET] : _t[TWEEN.TARGET].ref); // TODO: Maybe allow this to be skipped ??
		// Execute "On Play" event
		TGMX_ExecuteEvent(_t, TWEEN_EV_PLAY);
	}

	// RETURN WITH TWEEN ID
	return _tID;
}

/// @ignore
function TGMX_TweenPreprocess(_t) 
{
	/// @function TGMX_TweenPreprocess(tween_array)
	/// @description TGMX ADMIN: Prepares a tween's data to be useable
	/// @param tween_array
	
	// CACHE STRING POINTERS -- IMPROVES PERFORMANCE
	static STR_AT = "@";		static STR_AT_PLUS = "@+";		static STR_DOLLAR = "$";
	static STR_EMPTY = "";		static STR_SPACE = " ";			static STR_DOT = "."; 
	static STR_self = "self";	static STR_other = "other";		static STR_global = "global";
	
	// CACHE SOME OTHER THINGS!
	static TGMX_PropertySetters = global.TGMX.PropertySetters;
	static TGMX_PropertyNormals = global.TGMX.PropertyNormals;
	static TGMX_Variable_Dot_Notation_Set = global.TGMX.Variable_Dot_Notation_Set;
	static TGMX_Variable_Global_Set  = global.TGMX.Variable_Global_Set;
	static TGMX_Variable_Instance_Set = global.TGMX.Variable_Instance_Set;
	
	var _target = _t[TWEEN.TARGET];
	if (is_struct(_target)) { _target = _target.ref; }

	var _data_length = array_length(_t[TWEEN.PROPERTY_DATA_RAW]);
	var _pData = array_create(_data_length);
	array_copy(_pData, 0, _t[TWEEN.PROPERTY_DATA_RAW], 0, _data_length);
	
	var _propCount = _data_length  div 3;
	var _extIndex = -3; // Careful with this!
	var _extData = array_create(1+_propCount*4, undefined); // Create array holding properties data
	_extData[0] = _propCount; // Cache property count in first index (Used later when processing)
	
	var _caller = _t[TWEEN.CALLER];
	if (is_struct(_caller)) { _caller = _caller.ref; }
					
	var _other = _t[TWEEN.OTHER];
	if (is_struct(_other)) { _other = _other.ref; }
	
	// ** PARSE PROPERTY STRINGS **
	var i = -1;
	
	repeat(_propCount)
	{
		i += 1;
		var _variable = _pData[i];
	
		// PROCESS NEXT ARGUMENTS PASSED TO SETTER TYPE
		repeat(2)
		{
			i += 1;
			
			// CONTINUE IF WE HAVE A REAL NUMBER
			if (is_real(_pData[i])) { continue; }
			
			var _pValue = _pData[i];
		
			// RELATIVE ARRAY VALUES [100]
			if (is_array(_pValue))
			{	// ADD "+" FOR POSITIVE NUMBERS ... NO "-" NEEDED FOR NEGATIVE NUMBERS
				_pValue = _pValue[0] >= 0 ? STR_AT_PLUS+string(_pValue[0]) : STR_AT+string(_pValue[0]);
			}
	
			// STRING VALUES (START DEST)
			if (is_string(_pValue))
			{	// REMOVE ANY SPACES IN STRING
				_pValue = string_replace_all(_pValue, STR_SPACE, STR_EMPTY); 

				// CHECK FOR INITIAL MINUS SIGN
				var _preOp = 1;
				if (string_byte_at(_pValue, 1) == 45) // "-" MINUS
				{
					_preOp = -1;
					_pValue = string_delete(_pValue, 1, 1);
				}

				// TODO: THIS IS CAUSING AN ISSUE... POST-OP CAUSES PROBLEMS...
				var _op = 0;
				var _iOp = 1;
				repeat(string_length(_pValue)-2)
				{
					// TODO: add operator map check
					_iOp += 1;
					if (string_byte_at(_pValue, _iOp) != 46 && string_byte_at(_pValue, _iOp) <= 47 && string_byte_at(_pValue, _iOp) >= 42)
					{
						_op = _iOp;
						break;
					}
				}
			
				// UPDATE TWEEN_SELF MACRO
				global.TGMX.tween_self = _t[TWEEN.ID];
			
				if (_op) // HANDLE MATH OPERATION
				{		
					var _pre = string_copy(_pValue, 1, _op-1);
					var _post = string_copy(_pValue, _op+1, string_length(_pValue)-_op);
	
					_pre = _pre == STR_AT ? TGMX_Variable_Get(_target, _variable, _caller, _other) : TGMX_Variable_Get(_target, _pre, _caller, _other);
					_post = _post == STR_AT ? TGMX_Variable_Get(_target, _variable, _caller, _other) : TGMX_Variable_Get(_target, _post, _caller, _other);

					// PERFORM OPERATION
					switch(string_byte_at(_pValue, _op)) // TODO: Add _postOp??
					{
						case 43: _pData[i] = _preOp * _pre + _post; break; // + ADD
						case 45: _pData[i] = _preOp * _pre - _post; break; // - SUB
						case 42: _pData[i] = _preOp * _pre * _post; break; // * MULTIPLY
						case 47: _pData[i] = _preOp * _pre / _post; break; // / DIVIDE
					}
				}
				else // NO MATH OPERATION
				{	
					_pData[i] = _pValue == STR_AT ? _preOp*TGMX_Variable_Get(_target, _variable, _caller, _other) : _preOp*TGMX_Variable_Get(_target, _pValue, _caller, _other);
				}
				
				// Clear TWEEN_SELF macro
				global.TGMX.tween_self = undefined;
			}
		}
	
		// ** PROCESS PROPERTY DATA VALUES **
		_extIndex += 4;

		if (is_array(_variable)) // ADVANCED PROPERTY
		{
			// Track raw property setter method
			_extData[_extIndex] = TGMX_PropertySetters[? _variable[0]];
			
			if (ds_map_exists(TGMX_PropertyNormals, _variable[0])) // NORMALIZED
			{	
				_extData[1+_extIndex] = 0; // normalized start
				_extData[2+_extIndex] = 1; // normalized change
				var _data = _variable[1];
				_data[@ 1] = _pData[i-1]; // start
				_data[@ 2] = _pData[i]; // change
			}
			else // NOT NORMALIZED
			{	
				_extData[1+_extIndex] = _pData[i-1]; // start
				_extData[2+_extIndex] = _pData[i] - _pData[i-1]; // change
			}
		
			_extData[3+_extIndex] = _variable[1]; // data
		}
		else // METHOD PROPERTY (TPFunc)
		if (_target[$ STR_DOLLAR+_variable] != undefined)
		{
			_extData[  _extIndex] = _target[$ STR_DOLLAR+_variable];
			_extData[1+_extIndex] = _pData[i-1]; // start
			_extData[2+_extIndex] = _pData[i] - _pData[i-1]; // change
			_extData[3+_extIndex] = _variable; // data
		}
		else // OPTIMISED PROPERTY
		if (ds_map_exists(TGMX_PropertySetters, _variable))
		{
			_extData[_extIndex] = TGMX_PropertySetters[? _variable]; // Track raw property
			
			//if (!is_method(_variable) && ds_map_exists(global.TGMX.PropertyNormals, _variable))
			if (ds_map_exists(TGMX_PropertyNormals, _variable)) // NORMALIZED -- BUG IN HTML5 when checking method against a map?
			{
				_extData[_extIndex+1] = 0; // normalized start
				_extData[_extIndex+2] = 1; // normalized change
				_extData[_extIndex+3] = [_pData[i-1], _pData[i]];
			}
			else // NOT NORMALIZED
			{	
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				//_extData[3+_extIndex] = undefined; // data -- already set as default value for data array
			}
		}
		else // DYNAMIC PROPERTY
		{
			// NEW -- CHECK FOR STRUCTURE -- May need to extend this to support indexing object data
			var _dotPos = string_pos(STR_DOT, _variable);
			
			if (!_dotPos) // Default Dynamic Property
			{
				_extData[_extIndex] = _target[$ _variable] == undefined ? TGMX_Variable_Global_Set : TGMX_Variable_Instance_Set;
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				_extData[_extIndex+3] = _variable; // data
			}
			else // HANDLE DOT NOTATION
			{
				_extData[  _extIndex] = TGMX_Variable_Dot_Notation_Set; // Should rename this function for better clarity
				// These next 2 lines are potentionally redudant
				_extData[_extIndex+1] = _pData[i-1]; // start
				_extData[_extIndex+2] = _pData[i] - _pData[i-1]; // change
				
				// Handle difference between 1 or 2 dots used
				if (string_count(STR_DOT, _variable) == 1)
				{
					var _structName = string_copy(_variable, 1, _dotPos-1);
					// _extData[3+_extIndex] = undefined; // We will leave this undefined
				}
				else
				{
					var _sub_target = string_copy(_variable, 1, _dotPos-1);
					
					if (_target[$ _sub_target] != undefined)
					{
						_target = _target[$ _sub_target];
					}
					else
					if (_caller[$ _sub_target] != undefined)
					{
						_target = _caller[$ _sub_target];	
					}
					
					_variable = string_delete(_variable, 1, _dotPos);
					_dotPos = string_pos(STR_DOT, _variable);
					_structName = string_copy(_variable, 1, string_pos(STR_DOT, _variable)-1);
				}
				
				 // Lookup prefix inside target first
				if (_target[$ _structName] != undefined)
				{
					var _passTarget = _target[$ _structName];
						
					// Create weak reference if passed target is a struct
					if (!is_real(_passTarget)) 
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
					
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else // Look for prefix inside caller
				if (_caller[$ _structName] != undefined) 
				{
					var _passTarget = _caller[$ _structName];
						
					if (!is_real(_passTarget))
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
						
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{				
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else
				if (variable_global_exists(_structName)) // Look for prefix in global scope
				{
					var _passTarget = variable_global_get(_structName);
						
					if (!is_real(_passTarget))
					{
						_passTarget = weak_ref_create(_passTarget);	
					}
						
					// NEW =====================
					_variable = string_copy(_variable, _dotPos+1, 100);
					
					if (ds_map_exists(TGMX_PropertyNormals, _variable))
					{
						_extData[_extIndex+1] = 0; // start
						_extData[_extIndex+2] = 1; // change
						_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
					else
					{
						_extData[_extIndex+3] = [_passTarget, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
					}
				}
				else
				{		
					var _objectID = asset_get_index(_structName);	
			
					if (_objectID >= 0 && object_exists(_objectID))
					{
						// NEW =====================
						_variable = string_copy(_variable, _dotPos+1, 100);
					
						if (ds_map_exists(TGMX_PropertyNormals, _variable))
						{
							_extData[_extIndex+1] = 0; // start
							_extData[_extIndex+2] = 1; // change
							_extData[_extIndex+3] = [_objectID.id, _variable, [_pData[i-1], _pData[i]], undefined]; // This gets sorted later for optimised properties in the slower generic setter
						}
						else
						{
							_extData[_extIndex+3] = [_objectID.id, _variable, undefined, undefined]; // This gets sorted later for optimised properties in the slower generic setter
						}	
					}
					else
					{
						// This is where we need to handle self and other
						if (string_count(STR_DOT, _variable) >= 2)
						{
							var _structName = string_copy(_variable, 1, _dotPos-1);
							var _passTarget;
							switch(_structName)
							{
								case STR_global: // GLOBAL
									_variable = string_delete(_variable, 1, 7);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = variable_global_get(string_copy(_variable, 1, _dotPos-1));
								break;
								case STR_self: // SELF
									_variable = string_delete(_variable, 1, 5);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = _caller[$ string_copy(_variable, 1, _dotPos-1)];
								break;
								case STR_other: // OTHER
									_variable = string_delete(_variable, 1, 6);
									_dotPos = string_pos(STR_DOT, _variable);
									_passTarget = _other[$ string_copy(_variable, 1, _dotPos-1)];
								break;
							}
							
							// Finalize used target -- create weak reference if struct or get id if instance
							_passTarget = is_struct(_passTarget) ? weak_ref_create(_passTarget) : _passTarget.id;
							
							_variable = string_copy(_variable, _dotPos+1, 100);
							
							// Normalized
							if (ds_map_exists(TGMX_PropertyNormals, _variable))
							{
								_extData[_extIndex+1] = 0; // start
								_extData[_extIndex+2] = 1; // change
								_extData[_extIndex+3] = [_passTarget, _variable, [_pData[i-1], _pData[i]], undefined];
							}
							else
							{
								_extData[3+_extIndex] = [_passTarget, _variable, undefined, undefined];
							}
						}
						else
						{	
							_variable = string_copy(_variable, _dotPos+1, 100);
							
							switch(_structName)
							{
							case STR_global: // GLOBAL
								_extData[_extIndex] = global.TGMX.Variable_Global_Set;
								_extData[_extIndex+3] = _variable;
							break;
							case STR_self: // SELF
								// NORMALIZED PROPERTY
								if (ds_map_exists(TGMX_PropertyNormals, _variable))
								{
									_extData[_extIndex+1] = 0; // start
									_extData[_extIndex+2] = 1; // change
									_extData[_extIndex+3] = [(is_struct(_caller) ? weak_ref_create(_caller) : _caller), _variable, [_pData[i-1], _pData[i]], undefined];
								}
								else // NOT NORMALIZED PROPERTY
								{
									_extData[_extIndex+3] = [(is_struct(_caller) ? weak_ref_create(_caller) : _caller), _variable, undefined, undefined];
								}
							break; // OTHER
							case STR_other:
								// NORMALIZED PROPERTY
								if (ds_map_exists(TGMX_PropertyNormals, _variable))
								{
									_extData[_extIndex+1] = 0; // start
									_extData[_extIndex+2] = 1; // change
									_extData[_extIndex+3] = [(is_struct(_other) ? weak_ref_create(_other) : _other), _variable, [_pData[i-1], _pData[i]], undefined];
								} 
								else // NOT NORMALIZED PROPERTY
								{
									// NEW SINGLE
									_extData[_extIndex+3] = [(is_struct(_other) ? weak_ref_create(_other) : _other), _variable, undefined, undefined];
								}
							break;
							
							default:
								show_error("Invalid tween property prefix! Check preceding struct or object name.", false);
							}
						}
					}
				}
			}
		}		
	}
	
	// Assign property data values
	_t[@ TWEEN.PROPERTY_DATA] = _extData;
	
	// Handle per-step/second [durations]
	if (!is_real(_t[TWEEN.DURATION]))
	{
		var _duration = _t[TWEEN.DURATION];
		
		// Backwards array support for normalized [duration]
		if (is_array(_duration) && array_length(_duration) == 1)
		{
			_duration = {weight: _duration[0]}
		} // DONT PUT AN else BELOW HERE... IT NEEDS TO CARRY INTO THE STRUCT CHECK BELOW ON PURPOSE!
		
		if (is_struct(_duration))
		{	
			var _data = _t[TWEEN.PROPERTY_DATA];
			var _struct = _duration;
			var _absChangeSum = 0;
			var _count = _struct[$ "use"];

			if (_count == undefined) { _count = array_length(_data) div 4; }
		
			// Sum the absolute change values from each property
			var i = 3;	
			repeat(_count)
			{
				_absChangeSum += abs(_data[i]);
				i += 4;
			}
		
			if (!is_undefined(_struct[$ "rate"])) // Rate Duration
			{
				_t[@ TWEEN.DURATION] = _absChangeSum/_struct[$ "rate"];
			}
			else // Weighted Duration
			if (!is_undefined(_struct[$ "weight"]))
			{
				i = 3;
				var _output = 0;
				repeat(_count)
				{
					//var _rate_amount = _struct.weight * abs(_data[i]) / _absChangeSum;
					//_rate_amount = 1 + _rate_amount/_struct.weight;
					//_output += _data[i] * _rate_amount / _count;
				
					_output += abs(_data[i]) * (1 + (_struct.weight * abs(_data[i]) / _absChangeSum)/_struct.weight) / _count;
					i += 4;
				}
			
				_t[@ TWEEN.DURATION] = _output / _struct.weight;
			}
			else
			if (!is_undefined(_struct[$ "max"]))
			{	
				var _max = _data[3]; 
				i = 7;
				repeat(_count-1)
				{
					if (_data[i] > _max) 
					{ 
						_max = abs(_data[i]); 
					}
				
					i += 4;
				}
			
				_t[@ TWEEN.DURATION] = _max / _struct.max;
			}
			else
			if (!is_undefined(_struct[$ "min"]))
			{
				var _min = _data[3];
				i = 7;
				repeat(_count-1)
				{
					if (_data[i] < _min) 
					{ 
						_min = abs(_data[i]); 
					}
				
					i += 4;
				}
			
				_t[@ TWEEN.DURATION] = _min / _struct.min;
			}
			else // Divide Duration by Property Count "split"
			{
				_t[@ TWEEN.DURATION] = _absChangeSum/_struct[$ "split"]/_count;
			}
		}
	}
		
	// Make sure we don't have an invalid duration [0]
	if (_t[TWEEN.DURATION] <= 0)
	{
		_t[@ TWEEN.DURATION] = 0.000000001;	
	}
	
	// Adjust for amount
	if (_t[TWEEN.AMOUNT] > 0)
	{
		_t[@ TWEEN.TIME] = _t[TWEEN.AMOUNT] * _t[TWEEN.DURATION];	
	}
}

/// @ignore
function TGMX_TweenProcess(_t, _time, _d, _target) 
{ 	
	/// @function TGMX_TweenProcess(tween_array, time, data, target)
	/// @description TGMX ADMIN: Processes tween algorithm and updates properties
	/// @param tween
	/// @param time
	/// @param data
	/// @param target
	
	switch(_d[0]) // Property Count
	{
	case 1:
		if (is_method(_t[TWEEN.EASE]))
		{
			_d[1](_t[TWEEN.EASE](_time, _d[2], _d[3], _t[TWEEN.DURATION], _t), _target, _d[4], _t);
		}
		else
		{
			_d[1](_d[2] + _d[3]*animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]), _target, _d[4], _t); 
		}	
	break;
	
	case 2:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
		_d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
		_d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	break;
	
	case 3:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
	    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
	    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
	break;

	case 4:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
	    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
	    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
	    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
	break;
	
	case 5:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
	    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
	    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
	    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
	    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
	break;
	
	case 6:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
	    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
	    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
	    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
	    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
	    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
	break;
	
	case 7:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
	    _d[1](_time*_d[3]+_d[2], _target, _d[4], _t);
	    _d[5](_time*_d[7]+_d[6], _target, _d[8], _t);
	    _d[9](_time*_d[11]+_d[10], _target, _d[12], _t);
	    _d[13](_time*_d[15]+_d[14], _target, _d[16], _t);
	    _d[17](_time*_d[19]+_d[18], _target, _d[20], _t);
	    _d[21](_time*_d[23]+_d[22], _target, _d[24], _t);
	    _d[25](_time*_d[27]+_d[26], _target, _d[28], _t);
	break;
	
	case 8:
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
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
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
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
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
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
	
	case 0: // Break out for tweens with no properties
	break;
	
	default: // Handle "unlimited" properties
		_time = is_method(_t[TWEEN.EASE]) ? _t[TWEEN.EASE](_time, 0, 1, _t[TWEEN.DURATION], _t) : animcurve_channel_evaluate(_t[TWEEN.EASE], _time/_t[TWEEN.DURATION]);
		var i = 1;
		repeat(_d[0])
		{
			_d[i](_time*_d[i+2]+_d[i+1], _target, _d[i+3], _t);
			i += 4;
		}
	break;
	}
}

/// @ignore
function TGMX_ExecuteEvent(_t, _eventType) 
{	
	/// @function TGMX_ExecuteEvent(tween_array, event_type)
	/// @description TGMX_ADMIN: Executes a tween's event callbacks
	/// @param tween_array
	/// @param event_type
	
	static _ = SharedTweener();
	
	// SET EVENTS MAP FOR TweenIs*() CHECKS
	ds_map_set(global.TGMX.EventMaps[_eventType], _t[TWEEN.ID], 0);

	// IF EVENTS AND EVENT TYPE INITIALIZED...
	if (_t[TWEEN.EVENTS] != -1)
	{
	    if (ds_map_exists(_t[TWEEN.EVENTS], _eventType))
	    {
	        // GET EVENT DATA
	        _eventType = _t[TWEEN.EVENTS][? _eventType];
			// TRACK TWEEN SELF
			global.TGMX.tween_self = _t[TWEEN.ID];
			// INITIATE INDEX FOR LOOPING THROUGH ADDED CALLBACKS
			var _index = 0;
			
	        // Iterate through all event callbacks (isEnabled * event list size-1)
	        repeat(_eventType[| 0] * (ds_list_size(_eventType)-1))
	        {	
				_index += 1;
	            _t = _eventType[| _index]; // CACHE CALLBACK -- THIS IS ACTUALLY A CALLBACK... REUSING 'tween' to avoid local 'var' variable overhead!
   
				// FIRST CHECK TO SEE IF CALLBACK IS TO BE REMOVED
				if (_t[TWEEN_CB.TWEEN] == TWEEN_NULL)
				{
					ds_list_delete(_eventType, _index--);	
				}
				else // EXCEUTE CALLBACK SCRIPT WITH PROPER NUMBER OF ARGUMENTS
				if (_t[TWEEN_CB.ENABLED])
				{
					var _target = _t[TWEEN_CB.TARGET];
					
					// DO THIS PART AT CALLBACK EXECUTION
					if (is_struct(_target))
					{
						if (weak_ref_alive(_target))
						{
							_target = _target.ref;
						}
						else
						{
							continue;
						}
					}
					else
					if (!instance_exists(_target))
					{
						continue;
					}
					
					TWEEN_CALLBACK_SELF = _t;
					
					// Execute callback
					switch(array_length(_t)-TWEEN_CB.ARG)
					{
						case 0:  method(_target, _t[TWEEN_CB.SCRIPT])(); break;
						case 1:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG]); break;
						case 2:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1]); break;
						case 3:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2]); break;
						case 4:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3]); break;
						case 5:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4]); break;
						case 6:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5]); break;
						case 7:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6]); break;
						case 8:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7]); break;
						case 9:  method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8]); break;
						case 10: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9]); break;
						case 11: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10]); break;
						case 12: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11]); break;
						case 13: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12]); break;
						case 14: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13]); break;
						case 15: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14]); break;
						case 16: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15]); break;
						case 17: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16]); break;
						case 18: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17]); break;
						case 19: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18]); break;
						case 20: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18], _t[TWEEN_CB.ARG+19]); break;
						case 21: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18], _t[TWEEN_CB.ARG+19], _t[TWEEN_CB.ARG+20]); break;
						case 22: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18], _t[TWEEN_CB.ARG+19], _t[TWEEN_CB.ARG+20], _t[TWEEN_CB.ARG+21]); break;
						case 23: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18], _t[TWEEN_CB.ARG+19], _t[TWEEN_CB.ARG+20], _t[TWEEN_CB.ARG+21], _t[TWEEN_CB.ARG+22]); break;
						case 24: method(_target, _t[TWEEN_CB.SCRIPT])(_t[TWEEN_CB.ARG], _t[TWEEN_CB.ARG+1], _t[TWEEN_CB.ARG+2], _t[TWEEN_CB.ARG+3], _t[TWEEN_CB.ARG+4], _t[TWEEN_CB.ARG+5], _t[TWEEN_CB.ARG+6], _t[TWEEN_CB.ARG+7], _t[TWEEN_CB.ARG+8], _t[TWEEN_CB.ARG+9], _t[TWEEN_CB.ARG+10], _t[TWEEN_CB.ARG+11], _t[TWEEN_CB.ARG+12], _t[TWEEN_CB.ARG+13], _t[TWEEN_CB.ARG+14], _t[TWEEN_CB.ARG+15], _t[TWEEN_CB.ARG+16], _t[TWEEN_CB.ARG+17], _t[TWEEN_CB.ARG+18], _t[TWEEN_CB.ARG+19], _t[TWEEN_CB.ARG+20], _t[TWEEN_CB.ARG+21], _t[TWEEN_CB.ARG+22], _t[TWEEN_CB.ARG+23]); break;
					}
				}
	        }
			
			// CLEAR "TWEEN_SELF" -- WE NEED TO DO THIS SO THAT TWEEN_SELF MARCO WORKS PROPERLY INSIDE PROPERTY SCRIPT CALLS
			global.TGMX.tween_self = undefined;
	    }
	}
}

/// @ignore
function TGMX_TweensExecute() 
{	
	/// @function TGMX_TweensExecute(tweens, script, [args0, ...])
	/// @description TGMX ADMIN: Iterates over selected tweens and performs specified function for each
	/// @param tweens
	/// @param script
	/// @param [args0,...]
	
	// Currently takes only a max of 3 optional arguments

	var _tweens = SharedTweener().tweens;
	var _argCount = argument_count-2;
	var _tStruct = argument[0];
	var _script = argument[1];
	var _tIndex = -1;
	var _args = array_create(1+_argCount);
	
	var _argIndex = 0;
	repeat(_argCount)
	{
		_argIndex += 1;
		_args[_argIndex] = argument[_argIndex+1];
	}
	
	// TARGET SELECT
	static STR_Target = "target";
	if (variable_struct_exists(_tStruct, STR_Target))
	{	
		if (is_array(_tStruct.target)) // ARRAY
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
			    var _t = _tweens[| _tIndex];
			    var _target = _t[TWEEN.TARGET];
						
				if (TGMX_TargetExists(_target)) 
				{
					var i = -1;
					repeat(array_length(_tStruct.target))
					{
						i += 1;
						var _selectionData = _tStruct.target[i];
						
						if (_selectionData == _tStruct) 
						{ 
							_selectionData = self; 
						}
						
						if (is_struct(_target)) // STRUCT
						{
							if (is_struct(_selectionData) && _target.ref == _selectionData)
							{
								_args[0] = _t;
								script_execute_ext(_script, _args, 0, 1+_argCount);
							}
						}
						else // INSTANCE
						if (!is_struct(_selectionData) && instance_exists(_selectionData)) 
						{ 
							_selectionData = _selectionData.id;
							
							if (_target == _selectionData || _target.object_index == _selectionData || object_is_ancestor(_target.object_index, _selectionData))
							{
								_args[0] = _t;
								script_execute_ext(_script, _args, 0, 1+_argCount);
							}
						}	
					}
				}
			}
		}
		else
		if (_tStruct.target == all) // All Targets
		{	
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
	            
				if (TGMX_TargetExists(_t[TWEEN.TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args, 0, 1+_argCount);
				}
			}
		}
		else // Specific Target
		{
			var _selectionData = (_tStruct == _tStruct.target) ? self : _tStruct.target;
			
			if (!is_struct(_selectionData) && instance_exists(_selectionData))
			{
				_selectionData = _selectionData.id;	
			}
			
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = _tweens[| _tIndex];
		        var _target = _t[TWEEN.TARGET];
	
				if (TGMX_TargetExists(_target))
				{
					if (is_struct(_target))
					{
						if (_target.ref == _selectionData)
						{
							_args[0] = _t;
							script_execute_ext(_script, _args, 0, 1+_argCount);
						}
					}
					else
					if (is_real(_selectionData)) // Instance | Instance
					{
						if (_target == _selectionData || _target.object_index == _selectionData || object_is_ancestor(_target.object_index, _selectionData))
						{
							_args[0] = _t;
							script_execute_ext(_script, _args, 0, 1+_argCount);
						}
					}
				}
			}
		}
	}
	
	// GROUP
	static STR_Group = "group";
	var _select_group = _tStruct[$ STR_Group];
	if (_select_group != undefined)
	{	
		// SINGLE
		if (is_real(_select_group))
		{
			var _tIndex = -1;
			var _selectionData = _select_group;
        
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
		        if (_t[TWEEN.GROUP] == _selectionData && TGMX_TargetExists(_t[TWEEN.TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args, 0, 1+_argCount);	
				}
		    }
		}
		else // MULTI
		{
			var _tIndex = -1;
			
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
		        var _t = _tweens[| _tIndex];
				var i = -1;
				repeat(array_length(_select_group))
				{	
					i += 1;
					var _selectionData = _select_group[i];
					if (_t[TWEEN.GROUP] == _selectionData && TGMX_TargetExists(_t[TWEEN.TARGET]))
					{
						_args[0] = _t;
						script_execute_ext(_script, _args, 0, 1+_argCount);
					}
				}
		    }
		}
	}
	
	// TWEEN STRUCT IDS
	static STR_Tween = "tween";
	var _tweens = _tStruct[$ STR_Tween];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		// SINGLE
		if (is_real(_tweens))
		{
			var _t = TGMX_FetchTween(_tweens);
		    if (is_array(_t) && TGMX_TargetExists(_t[TWEEN.TARGET]))
			{
				_args[0] = _t;
				script_execute_ext(_script, _args, 0, 1+_argCount);
			}
		}
        else // ARRAY
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
		        var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TWEEN.TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args, 0, 1+_argCount);
				}
		    }
		}
	}
	
	// TWEEN LISTS OR ARRAYS
	static STR_List = "list";
	_tweens = _tStruct[$ STR_List];
	if (_tweens != undefined)
	{
		var _tIndex = -1;
		
		if (is_array(_tweens)) // array
		{
			repeat(array_length(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[_tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TWEEN.TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args, 0, 1+_argCount);
				}
			}
		}
		else // ds_list
		{
			repeat(ds_list_size(_tweens))
			{
				_tIndex += 1;
				var _t = TGMX_FetchTween(_tweens[| _tIndex]);
		        if (is_array(_t) && TGMX_TargetExists(_t[TWEEN.TARGET]))
				{
					_args[0] = _t;
					script_execute_ext(_script, _args, 0, 1+_argCount);
				}
			}
		}
	}
}




















