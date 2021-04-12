params ["_object","_condition"];

[{!isNil "spec_arsenal_blacklistedFromArsenal" && !isNil "spec_arsenal_virtualCargo"}, {
    _this params ["_object", "_condition"];
    [{(count spec_arsenal_blacklistedFromArsenal) > 0}, {
        _this params ["_object", "_condition"];

        private _virtualWeapons = [];
        private _virtualMagazines = [];
        private _virtualItems = [];
        private _virtualBackpacks = [];

        {if (!(_x in spec_arsenal_blacklistedFromArsenal)) then {_virtualWeapons pushBack _x};} forEach (spec_arsenal_virtualCargo # 0);
        {if (!(_x in spec_arsenal_blacklistedFromArsenal)) then {_virtualMagazines pushBack _x};} forEach (spec_arsenal_virtualCargo # 1);
        {if (!(_x in spec_arsenal_blacklistedFromArsenal)) then {_virtualItems pushBack _x};} forEach (spec_arsenal_virtualCargo # 2);
        {if (!(_x in spec_arsenal_blacklistedFromArsenal)) then {_virtualBackpacks pushBack _x};} forEach (spec_arsenal_virtualCargo # 3);

        [missionNamespace, _virtualWeapons] call BIS_fnc_addVirtualWeaponCargo;
        [missionNamespace, _virtualMagazines] call BIS_fnc_addVirtualMagazineCargo;
        [missionNamespace, _virtualItems] call BIS_fnc_addVirtualItemCargo;
        [missionNamespace, _virtualBackpacks] call BIS_fnc_addVirtualBackpackCargo;

        spec_arsenal_filteredItems = flatten [_virtualItems, _virtualMagazines, _virtualWeapons, _virtualBackpacks];
        publicVariable "spec_arsenal_filteredItems";

        _object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_BIS", {['Open', [_this # 3 # 0, _this # 0]] call bis_fnc_arsenal;}, [_condition]];
        _object addAction [localize "STR_BTC_HAM_ACTION_ARSENAL_OPEN_ACE", {[_this # 3 # 0, player] call ace_arsenal_fnc_openBox;}, [_object]];

        private _cargo = [spec_arsenal_filteredItems] call SPEC_fnc_arsenal_aceVirtualItems;
        _object setVariable ["ace_arsenal_virtualItems",_cargo];

        ["ArsenalLoaded"] call BIS_fnc_showNotification;
    }, [_object, _condition]] call CBA_fnc_waitUntilAndExecute;
}, [_object, _condition]] call CBA_fnc_waitUntilAndExecute;
