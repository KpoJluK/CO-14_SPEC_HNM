if(isNil "Call_help_paradrop")then{
	Call_help_paradrop = false;
	publicVariable "Call_help_paradrop";
};
if(Call_help_paradrop)exitWith{hint "Самолет еще не готов для взлета!"};
[5, [], {

	0 spawn {
		Call_help_paradrop = true;
		publicVariable "Call_help_paradrop";
		[[], {systemChat "По вашим координатам выслан борт десантом, сброс будет по вашим текущим координатм, ожидайте!"}] remoteExec ["call"];
		//Записуем позицию игрока
		_Position_player = getPos player;
		//спуним самолет
		_C_130 = [[0,0,1000], 180, "RHS_C130J_Cargo", WEST] call BIS_fnc_spawnVehicle;
		{_x setSkill ["courage", 1]} forEach units (_C_130 select 2);
		// Приказываем самолету двигаться куда над
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
		// создаю группу десанта
		private _group_desant = createGroup [WEST, true];
		_pos_C_130 = getPosATL (_C_130 select 0);
		for "_i" from 0 to 15 do
		{
			_pos_X = (_pos_C_130 select 0) + random [-100,0,100];
			_pos_Y = (_pos_C_130 select 1) + random [-100,0,100];
			_pos_Z = (_pos_C_130 select 2) + random [-100,0,100];

			_unit_desant = _group_desant createUnit ["B_officer_F",[_pos_X, _pos_Y, _pos_Z], [], 0, "FORM"];
			_unit_desant setSkill 1;

			comment "Remove existing items";
			removeAllWeapons _unit_desant;
			removeAllItems _unit_desant;
			removeAllAssignedItems _unit_desant;
			removeUniform _unit_desant;
			removeVest _unit_desant;
			removeBackpack _unit_desant;
			removeHeadgear _unit_desant;
			removeGoggles _unit_desant;

			comment "Add weapons";
			_unit_desant addWeapon "Tier1_HK416D145_SMR_MFT_Desert";
			_unit_desant addPrimaryWeaponItem "Tier1_KAC_556_QDC_CQB_Tan";
			_unit_desant addPrimaryWeaponItem "Tier1_145_LA5_Side";
			_unit_desant addPrimaryWeaponItem "Tier1_ATACR18_ADM_Desert";
			_unit_desant addPrimaryWeaponItem "rhs_mag_30Rnd_556x45_Mk318_Stanag";
			_unit_desant addPrimaryWeaponItem "Tier1_Gangster_Grip_Tan";
			_unit_desant addWeapon "rhs_weap_M136_hedp";

			comment "Add containers";
			_unit_desant forceAddUniform "gen3_cryes_l";
			_unit_desant addVest "Crye_AVS23_NoBelt";
			_unit_desant addBackpack "moh_Parachute_low";

			comment "Add items to containers";
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_epinephrine";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_tourniquet";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_morphine";};
			for "_i" from 1 to 4 do {_unit_desant addItemToUniform "ACE_quikclot";};
			for "_i" from 1 to 4 do {_unit_desant addItemToUniform "ACE_elasticBandage";};
			for "_i" from 1 to 4 do {_unit_desant addItemToUniform "ACE_fieldDressing";};
			for "_i" from 1 to 4 do {_unit_desant addItemToUniform "ACE_packingBandage";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "ACE_splint";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "HandGrenade";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "SmokeShell";};
			for "_i" from 1 to 2 do {_unit_desant addItemToUniform "rhs_mag_30Rnd_556x45_Mk318_Stanag_Pull";};
			for "_i" from 1 to 14 do {_unit_desant addItemToVest "rhs_mag_30Rnd_556x45_Mk318_Stanag_Pull";};
			_unit_desant addHeadgear "airframe_cover_25_ComtacIII_Arc";
			_unit_desant addGoggles "tfl_arc_bala_glasses_mc";
		};
		_group_desant enableGunLights "ForceOn";
		// группе ботов охранять зону игрока
 		_wp = _group_desant addWaypoint [_Position_player, 0];
   		_wp setWaypointType "HOLD";
		//ждать пока игроков не будет для удаления группы
		[_group_desant, _Position_player] spawn{
			params ["_group_desant","_Position_player"];
			waitUntil{
				sleep 10;
				_player_in_area = allPlayers inAreaArray [_Position_player, 500, 500, 100, false];
    			isNil {_player_in_area select 0}
			};
			{deleteVehicle _x} forEach (units _group_desant);
		};
		// удаляю С 130
		(_C_130 select 0) flyInHeight 4000;
		waitUntil{
			sleep 5;
			(getPosATL(_C_130 select 0)select 2) >=3000
		};
		sleep 2400;
		Call_help_paradrop = false;
		publicVariable "Call_help_paradrop";

	};
}, {hint "Отмена передачи"}, "Определение и передача координат..."] call ace_common_fnc_progressBar;
