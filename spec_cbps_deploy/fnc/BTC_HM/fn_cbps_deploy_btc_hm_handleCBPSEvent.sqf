params [
    ["_vehicle", objNull, [objNull]],
    ["_action", "", [""]],
    ["_pos", [], [[]]]
];

private _closeTentText = getText (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "close_tent" >> "displayName");
private _openTentText = getText (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "open_tent" >> "displayName");

if (_action isEqualTo _openTentText) exitWith {
    [{
        _this params ["_pos", "_vehicle"];
        [_pos, "FOB Spartan", _vehicle] remoteExecCall ["SPEC_fnc_cbps_deploy_btc_hm_createFob", 0, true];
    }, [_pos, _vehicle], 5] call CBA_fnc_waitAndExecute;
};

if (_action isEqualTo _closeTentText) exitWith {
    [{
        _this params ["_vehicle"];
        [_vehicle, objNull, objNull, true, false] remoteExecCall ["SPEC_fnc_cbps_deploy_btc_hm_fobKilled", 0, true];
    }, [_vehicle], 5] call CBA_fnc_waitAndExecute;
};

false
