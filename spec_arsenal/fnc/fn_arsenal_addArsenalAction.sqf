params ["_object"];

[{!isNil "BLACKLISTED_FROM_ARSENAL" && !isNil "VIRTUAL_CARGO"}, {
    _this params ["_object"];
    [{(count BLACKLISTED_FROM_ARSENAL) > 0}, {
        _this params ["_object"];

        private _virtualWeapons = [];
        private _virtualMagazines = [];
        private _virtualItems = [];
        private _virtualBackpacks = [];

        {if (!(_x in BLACKLISTED_FROM_ARSENAL)) then {_virtualWeapons pushBack _x};} forEach (VIRTUAL_CARGO select 0);
        {if (!(_x in BLACKLISTED_FROM_ARSENAL)) then {_virtualMagazines pushBack _x};} forEach (VIRTUAL_CARGO select 1);
        {if (!(_x in BLACKLISTED_FROM_ARSENAL)) then {_virtualItems pushBack _x};} forEach (VIRTUAL_CARGO select 2);
        {if (!(_x in BLACKLISTED_FROM_ARSENAL)) then {_virtualBackpacks pushBack _x};} forEach (VIRTUAL_CARGO select 3);

        [missionNamespace, _virtualWeapons] call BIS_fnc_addVirtualWeaponCargo;
        [missionNamespace, _virtualMagazines] call BIS_fnc_addVirtualMagazineCargo;
        [missionNamespace, _virtualItems] call BIS_fnc_addVirtualItemCargo;
        [missionNamespace, _virtualBackpacks] call BIS_fnc_addVirtualBackpackCargo;

        FILTERED_ITEMS = (_virtualWeapons + _virtualMagazines + _virtualItems + _virtualBackpacks);
        publicVariable "FILTERED_ITEMS";

        btc_gear_object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_BIS", "['Open', [!(btc_p_arsenal_Restrict isEqualTo 1 || btc_p_arsenal_Restrict isEqualTo 4), _this select 0]] call bis_fnc_arsenal;"];
        btc_gear_object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_ACE", "[btc_gear_object, player] call ace_arsenal_fnc_openBox;"];

        private _cargo = [FILTERED_ITEMS] call SPEC_fnc_arsenal_aceVirtualItems;
        btc_gear_object setVariable ["ace_arsenal_virtualItems",_cargo];

        ["ArsenalLoaded"] call BIS_fnc_showNotification;
    }, [_object]] call CBA_fnc_waitUntilAndExecute;
}, [_object]] call CBA_fnc_waitUntilAndExecute;
