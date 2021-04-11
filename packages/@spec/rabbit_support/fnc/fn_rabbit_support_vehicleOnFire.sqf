// arry vehicle in fire
vehicle_on_fire = [];

//fire and smoke

fn_createEffect =
{
	private["_effect","_pos","_fire","_smoke"];
	private["_light","_brightness","_color","_ambient","_intensity","_attenuation"];
	private["_eFire","_eSmoke"];
	//["[PARTICLE EFFECT CREATED]: %1",_this] call BIS_fnc_logFormat;

	_pos 	= _this select 0;
	_effect = _this select 1;

	_fire	= "";
	_smoke	= "";
	_light	= objNull;
	_eFire = objNull;
	_eSmoke = objNull;
	/*
	_color		= [1,0.85,0.6];
	_ambient	= [1,0.45,3];
	*/

	_color		= [1,0.85,0.6];
	_ambient	= [1,0.3,0];


	switch (_effect) do
	{
		case "FIRE_SMALL":
		{
			_fire 	= "SmallDestructionFire";
			_smoke 	= "SmallDestructionSmoke";
		};
		case "FIRE_MEDIUM":
		{
			_fire 	= "MediumDestructionFire";
			_smoke 	= "MediumDestructionSmoke";

			_brightness	= 1.0;
			//_color	= [1,0.85,0.6];
			//_ambient	= [1,0.3,0];
			_intensity	= 400;
			_attenuation	= [0,0,0,2];
		};
		case "FIRE_BIG":
		{
			_fire 	= "BigDestructionFire";
			_smoke 	= "BigDestructionSmoke";

			_brightness	= 1.0;
			//_color	= [1,0.85,0.6];
			//_ambient	= [1,0.45,3];
			_intensity	= 1600;
			_attenuation	= [0,0,0,1.6];
		};
		case "SMOKE_SMALL":
		{
			_smoke 	= "SmallDestructionSmoke";
		};
		case "SMOKE_MEDIUM":
		{
			_smoke 	= "MediumSmoke";
		};
		case "SMOKE_BIG":
		{
			_smoke 	= "BigDestructionSmoke";
		};
	};

	if (_fire != "") then
	{
		_eFire = "#particlesource" createVehicle _pos;
		_eFire setParticleClass _fire;
		_eFire setPosATL _pos;
	};

	if (_smoke != "") then
	{
		_eSmoke = "#particlesource" createVehicle _pos;
		_eSmoke setParticleClass _smoke;
		_eSmoke setPosATL _pos;
	};

	//create lightsource
	if (_effect in ["FIRE_BIG","FIRE_MEDIUM"]) then
	{
		_pos   = [_pos select 0,_pos select 1,(_pos select 2)+1];
		_light = createVehicle ["#lightpoint", _pos, [], 0, "CAN_COLLIDE"];
		_light setPosATL _pos;

		_light setLightBrightness _brightness;
		_light setLightColor _color;
		_light setLightAmbient _ambient;
		_light setLightIntensity _intensity;
		_light setLightAttenuation _attenuation;
		_light setLightDayLight false;
	};
	[_eFire, _eSmoke, _light]
};

while {true} do {
	// all vehicle
	_vehicle = nearestObjects [[0,0,0], ["Car"], 15000];
		{ if(_x getHitPointDamage "hitEngine" > 0.8) then{
			if(_x in vehicle_on_fire or !alive _x)exitWith{};
			vehicle_on_fire pushBack _x;
			[_x] spawn {
				params ["_vehicle_select"];
				_fire_this_vehicle = [getPos _vehicle_select, "FIRE_MEDIUM"] call fn_createEffect;
				{_x attachTo [_vehicle_select, [0, 1.5, -0.7]]} forEach _fire_this_vehicle;
				_damage = 0;
				waitUntil{
					sleep 1;
					_damage = _damage + 1;
					if(_damage >= 90)exitWith{true};
					!alive _vehicle_select or _vehicle_select getHitPointDamage "hitEngine" <= 0.6;
				};
				if(_damage >=90)then{_vehicle_select setDamage 1};
				[[], {{deleteVehicle _x} forEach _fire_this_vehicle;}] remoteExec ["call"];
				vehicle_on_fire = vehicle_on_fire - [_vehicle_select];
			}
		}
	} forEach _vehicle;
	sleep 15;
};
