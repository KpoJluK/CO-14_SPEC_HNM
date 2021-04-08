if(isNil "Call_transport")then{
	Call_transport = false;
	publicVariable "Call_transport";
};
if(Call_transport)exitWith{hint "Запрос отклонен! Идет погрузка нового транспорта в самолет ожидайте..."};
[5, [], {
	0 spawn {
		Call_transport = true;
		publicVariable "Call_transport";
		[[], {systemChat "По вашим координатам выслан борт с танспортом, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];
		// берем позицию игрока
		_Position_player = getPos player;
		//спуним самолет
		_C_130 = [[0,0,1000], 180, "RHS_C130J_Cargo", WEST] call BIS_fnc_spawnVehicle;
		{_x setSkill ["courage", 1]} forEach units (_C_130 select 2);
		// Приказываем самолету двигаться куда надо
		private _wp_C_130 = (_C_130 select 2) addWaypoint [_Position_player, 0];
		_wp_C_130 setWaypointType "MOVE";
		_wp_C_130 setWaypointSpeed "FULL";
		[(_C_130 select 2), 0] setWaypointCombatMode "BLUE";

		(_C_130 select 0) flyInHeight 1000;
		// жду пока самолет булет над точкой
		waitUntil{
			sleep 1;
			((getPos (_C_130 select 0)) inArea [_Position_player, 150, 150, 0, false])
		};
			[_C_130] spawn {
				params ["_C_130"];
				// спауним джип
				_jeep = "rhsusf_mrzr4_d" createVehicle [0,0,1000];
				_pos_plane = getPosATL (_C_130 select 0);
				sleep 1;
				_jeep setPosATL _pos_plane;
				// Удаляю инвентарь и добавляю новый
				clearMagazineCargoGlobal _jeep;
				clearWeaponCargoGlobal _jeep;
				clearBackpackCargoGlobal _jeep;
				clearItemCargoGlobal _jeep;
				//Создаю контейнер
				_Ammo_container = "Box_NATO_WpsSpecial_F" createVehicle (_jeep getPos [5, random 360]);
				_Ammo_container disableCollisionWith _jeep;
				_Ammo_container attachTo [_jeep, [0, 1.5, -0.3]];
				// Удаляю инвентарь и добавляю новый
				clearMagazineCargoGlobal _Ammo_container;
				clearWeaponCargoGlobal _Ammo_container;
				clearBackpackCargoGlobal _Ammo_container;
				clearItemCargoGlobal _Ammo_container;

				_Ammo_container addMagazineCargo ["SSOT_45rnd_PMAG_FDE_318",20];
				_Ammo_container addMagazineCargo ["SSOT_40rnd_PMAG_FDE_318",20];
				_Ammo_container addItemCargoGlobal ["HandGrenade", 4];
				_Ammo_container addItemCargoGlobal ["SmokeShellGreen", 2];
				_Ammo_container addItemCargoGlobal ["SmokeShellRed", 2];
				_Ammo_container addItemCargoGlobal ["SmokeShellBlue", 2];
				_Ammo_container addItemCargoGlobal ["SmokeShell", 2];

				_Ammo_container addItemCargoGlobal ["ACE_bloodIV_250", 4];
				_Ammo_container addItemCargoGlobal ["ACE_bloodIV_500", 2];
				_Ammo_container addItemCargoGlobal ["ACE_morphine", 5];
				_Ammo_container addItemCargoGlobal ["ACE_quikclot", 10];
				_Ammo_container addItemCargoGlobal ["ACE_elasticBandage", 10];
				_Ammo_container addItemCargoGlobal ["ACE_fieldDressing", 10];
				_Ammo_container addItemCargoGlobal ["ACE_packingBandage", 10];
				_Ammo_container addItemCargoGlobal ["ACE_splint", 5];
				_Ammo_container addItemCargoGlobal ["ACE_epinephrine", 5];
				_Ammo_container addItemCargoGlobal ["ACE_WaterBottle", 4];
				_Ammo_container addItemCargoGlobal ["ACE_MRE_LambCurry", 5];
				_Ammo_container addItemCargoGlobal ["CE_CableTie", 5];
				_Ammo_container addItemCargoGlobal ["ACE_bodyBag", 4];

				_Ammo_container addWeaponCargoGlobal ["Tier1_HK416D145_SMR_MFT_Desert", 2];
				// ждем пока дистанция до земли будет 200 м
				waitUntil{
					_pos_jeep = getPosATl _jeep ;
					(_pos_jeep select 2) <= 100
				};
				//прикрепляю парашут
				_Parachute = createVehicle ["B_Parachute_02_F",GetPosAtl _jeep, [], 0, "FLY"];
				_Parachute disableCollisionWith _jeep;
				_Parachute setPos(getPos _jeep);
				_jeep attachTo [_Parachute, [0, 0, 1.8]];
				//если день тогда добавить дым если ноч ик маяк
				if(daytime <= 6 or daytime >= 20) then{
					_ir_signal = "B_IRStrobe" createVehicle [0,0,0];
					_ir_signal disableCollisionWith _jeep;
					_ir_signal attachTo [_jeep, [0, 0, 0.3]];
				}
				else{
					_smoke = "G_40mm_SmokeGreen" createVehicle [0,0,0];
					_smoke disableCollisionWith _jeep;
					_smoke attachTo [_jeep, [0, 0, 0.3]];
				};
			};

		// возвращаю самолет на позицию 0 и удаляю
		(_C_130 select 0) flyInHeight 4000;
		sleep 30;
		{(_C_130 select 0) deleteVehicleCrew _x } forEach (_C_130 select 1);
		deleteVehicle (_C_130 select 0);
		sleep 600;
		Call_transport = true;
		publicVariable "Call_transport";
	};

}, {hint "Передача координат отменена!"}, "Передача координат для сброса транспорта..."] call ace_common_fnc_progressBar;
