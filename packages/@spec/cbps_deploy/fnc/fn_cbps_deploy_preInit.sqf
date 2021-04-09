if (isServer) then {
    ["SPEC_cbps_deploy_cbpsChanged", {
        _this call SPEC_fnc_cbps_deploy_btc_hm_handleCBPSEvent;
    }] call CBA_fnc_addEventHandler;
};
