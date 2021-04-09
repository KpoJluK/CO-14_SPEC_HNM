// Axon 76561198016173803
// Reidond 76561198117480403
private _uids = ["76561198016173803","76561198117480403"];

{
    private _player = _x call BIS_fnc_getUnitByUID;
    _player setVariable ["side_mission", true, true];
} forEach _uids;

true
