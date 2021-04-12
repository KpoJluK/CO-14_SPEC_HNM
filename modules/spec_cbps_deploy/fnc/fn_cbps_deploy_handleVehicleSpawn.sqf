params [
    ["_vehicle", objNull, [objNull]]
];

switch (typeOf _vehicle) do {
    case "rhsusf_M1085A1P2_B_D_Medical_fmtv_usarmy": {
        if ([_vehicle] call SPEC_fnc_cbps_deploy_isCBPS) then {
            private _onAction = '
                params ["_target", "_caller", "", "_action", "_name", "", "", "", "", "", "_event"];
                if (_action == "User" || _action == "UserType") then {
                    if (_event == "Action") then {
                        private _closeTentText = getText (configfile >> "CfgVehicles" >> (typeOf vehicle _target) >> "UserActions" >> "close_tent" >> "displayName");
                        private _openTentText = getText (configfile >> "CfgVehicles" >> (typeOf vehicle _target) >> "UserActions" >> "open_tent" >> "displayName");

                        if (_closeTentText isEqualTo _name) then {
                            ["SPEC_cbps_deploy_cbpsChanged", [vehicle _target, _name, getPos (vehicle _target)]] call CBA_fnc_serverEvent;
                        };
                        if (_openTentText isEqualTo _name) then {
                            ["SPEC_cbps_deploy_cbpsChanged", [vehicle _target, _name, getPos (vehicle _target)]] call CBA_fnc_serverEvent;
                        };
                    };
                };
                false
            ';

            inGameUISetEventHandler ["PrevAction", ""];
            inGameUISetEventHandler ["NextAction", ""];
            inGameUISetEventHandler ["Action", ""];
            inGameUISetEventHandler ["PrevAction", _onAction];
            inGameUISetEventHandler ["NextAction", _onAction];
            inGameUISetEventHandler ["Action", _onAction];
        };
    };
};

true
