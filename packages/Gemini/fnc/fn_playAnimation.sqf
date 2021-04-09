/*
	EXAMPLE :
	[player, "Acts_carFixingWheel", "playMove", {dayTime > 12}] spawn Gemini_fnc_playAnimation;
	[unitA, "AmovPercMstpSnonWnonDnon_exercisePushup", "playMove", {true}] spawn Gemini_fnc_playAnimation;
	[unitA, "AmovPercMstpSnonWnonDnon_exercisePushup", "playMove", {true}] remoteExec ["Gemini_fnc_playAnimation", 0, unitA];
*/


	//if (isDedicated) exitWith {};

// =========================================================================================================
// PRIVATIZING LOCAL VARIABLES
// =========================================================================================================

	params [
        ["_unit", player, [objNull]],
        ["_animation", "", [""]],
        ["_command", "playMove", [""]],
        ["_condition", (!alive (_this select 0)) || (behaviour (_this select 0) != "combat"), [true]]
    ];

// =========================================================================================================
// PLAYING ACTION
// =========================================================================================================

	private _position = position _unit;
	_unit setPos _position;
	_unit enableSimulationGlobal true;

	if (_command == "switchMove") then
		{
			while {_condition} do
				{
					sleep 5;
					_unit switchMove _animation;
					waitUntil {sleep 0.1; animationState _unit != _animation};
					_unit setPos _position;
				};
			_unit switchMove "";
		};

	if (_command == "playMove") then
		{
			while {_condition} do
				{
					sleep 5;
					_unit playMove _animation;
					waitUntil {sleep 0.1; animationState _unit != _animation};
					_unit setPos _position;
				};
			_unit playMove "";
		};

// =========================================================================================================
// EXITING SCRIPT
// =========================================================================================================

	if (true) exitWith {};
