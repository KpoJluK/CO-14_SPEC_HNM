BLACKLISTED_FROM_ARSENAL_COMMON = [];
BLACKLISTED_FROM_ARSENAL = [];

["common"] call SPEC_fnc_arsenal_compileBlacklistPreset;

["rhs_blufor"] call SPEC_fnc_arsenal_compileBlacklistPreset;

BLACKLISTED_FROM_ARSENAL append BLACKLISTED_FROM_ARSENAL_COMMON;
