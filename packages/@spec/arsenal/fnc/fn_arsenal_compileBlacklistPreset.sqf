/*
    * Author: [SpecOps Liberation Dev Team - https://gitlab.com/armachovsk]
    *
    * Arguments:
    * 0: Name of preset without .yml <STRING>
    *
    * Return Value:
    * The return value <VOID>
    *
    * Example:
    * ["preset_name"] call specm_fnc_compileBlaclistPreset
    *
    * Public: No
*/
params ["_preset"];

private _file = preprocessFile format ["packages\@spec\arsenal\presets\%1.json", _preset];
private _hash = [_file, true] call CBA_fnc_parseJSON;

BLACKLISTED_FROM_ARSENAL_COMMON append _hash;

_hash
