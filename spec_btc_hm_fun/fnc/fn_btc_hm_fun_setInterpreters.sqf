// Rieper 76561198344540395
// Reidond 76561198117480403
private _uids = ["76561198344540395","76561198117480403"];

{
    private _player = _x call BIS_fnc_getUnitByUID;
    _player setVariable ["interpreter", true, true];
} forEach _uids;

true
