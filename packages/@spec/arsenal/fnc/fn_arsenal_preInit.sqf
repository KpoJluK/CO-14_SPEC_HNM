if (isDedicated) then {
  [] call SPEC_fnc_arsenal_serverInit;
};

if (isServer && !isDedicated) then {
  [] call SPEC_fnc_arsenal_serverInit;
};