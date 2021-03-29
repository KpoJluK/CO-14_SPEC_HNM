params [
    ["_globalVehicle", objNull, [objNull]]
];

if (isNil "_globalVehicle") exitWith {false};

[_globalVehicle] remoteExecCall ["SPEC_fnc_cbps_deploy_handleVehicleSpawn", 0, true];
[_globalVehicle, 10] call btc_fnc_eh_veh_add_respawn;
["btc_veh_spawned", {
    _this params ["_vehicle"];
    [_vehicle] remoteExecCall ["SPEC_fnc_cbps_deploy_handleVehicleSpawn", 0, true];
}] call CBA_fnc_addEventHandler;

true;
