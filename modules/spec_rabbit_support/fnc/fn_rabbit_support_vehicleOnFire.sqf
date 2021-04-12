// arry vehicle in fire
vehicle_on_fire = [];

while {true} do {
	// all vehicle
	_vehicle = nearestObjects [[0,0,0], ["Car"], 15000];
		{ if(_x getHitPointDamage "hitEngine" > 0.8) then{
			if(_x in vehicle_on_fire or !alive _x)exitWith{};
			vehicle_on_fire pushBack _x;
			[_x] spawn {
				params ["_vehicle_select"];
				// create fire
				_Fire = "#particlesource" createVehicle [0,0,0]; 
				_Fire setParticleClass "MediumDestructionFire"; 
				_Fire attachTo [_vehicle_select, [0, 1.5, -0.7]];
				// create smoke
				_Smoke = "#particlesource" createVehicle [0,0,0]; 
				_Smoke setParticleClass "MediumDestructionSmoke"; 
				_Smoke attachTo [_vehicle_select, [0, 1.5, -0.7]];
				// create light
				_light = createVehicle ["#lightpoint", [0,0,0], [], 0, "CAN_COLLIDE"];
				_light attachTo [_vehicle_select, [0, 1.5, -0.7]];
				_light setLightBrightness 1.0;
				_light setLightColor [1,0.85,0.6];
				_light setLightAmbient [1,0.3,0];
				_light setLightIntensity 400;
				_light setLightAttenuation [0,0,0,2];
				_light setLightDayLight true;
				// time to destroid
				_time_to_destroid = 60 + random 40;
				// wait until !alive vehicle or "hitEngine" <= 0.6
				waitUntil{
					sleep 1;
					_time_to_destroid = _time_to_destroid - 1;
					if(_time_to_destroid <= 0)exitWith{true};
					!alive _vehicle_select or _vehicle_select getHitPointDamage "hitEngine" <= 0.6;
				};
				if(_time_to_destroid <=0)then{_vehicle_select setDamage 1};
				deleteVehicle _Fire;
				deleteVehicle _Smoke;
				deleteVehicle _light;
				vehicle_on_fire = vehicle_on_fire - [_vehicle_select];
			}
		}
	} forEach _vehicle;
	sleep 15;
};

