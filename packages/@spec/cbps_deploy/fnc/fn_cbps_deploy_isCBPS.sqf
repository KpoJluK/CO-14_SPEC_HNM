params [
    ["_vehicle", objNull, [objNull]]
];

(isClass (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "close_tent")) && (isClass (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "UserActions" >> "open_tent"))
