params [
    ["_vehicle", objNull, [objNull]],
    ["_action", "", [""]],
    ["_pos", [], [[]]]
];

private _closeTentText = getText (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "close_tent" >> "displayName");
private _openTentText = getText (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "open_tent" >> "displayName");

if (_action isEqualTo _openTentText) exitWith {
    [_pos, "FOB Spartan", _vehicle] remoteExecCall ["SPEC_fnc_cbps_deploy_btc_hm_createFob", 0];
};

if (_action isEqualTo _closeTentText) exitWith {
    [_vehicle, objNull, objNull, true, false] remoteExecCall ["SPEC_fnc_cbps_deploy_btc_hm_fobKilled", 0];
};

false
