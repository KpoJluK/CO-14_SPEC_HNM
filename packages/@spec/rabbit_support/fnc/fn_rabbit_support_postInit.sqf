if (!isDedicated && hasInterface) then {
    private _action_call_help = ["TestAction_call_help","Запросить поддержку","",{[] call SPEC_fnc_rabbit_support_callHelpVdv;},{true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action_call_help] call ace_interact_menu_fnc_addActionToObject;

    private _action_call_help_transport = ["TestAction_call_help","Запросить сброс транспорта","",{[] call SPEC_fnc_rabbit_support_callDropTransport;},{true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action_call_help_transport] call ace_interact_menu_fnc_addActionToObject;

    private _action_call_help_transport_V2 = ["TestAction_call_help","Запросить сброс тяжелого транспорта","",{[] call SPEC_fnc_rabbit_support_callDropTransport_V2;},{true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action_call_help_transport_V2] call ace_interact_menu_fnc_addActionToObject;

    private _action_call_help_paradrop = ["TestAction_call_help","Запросить паращютистов","",{[] call SPEC_fnc_rabbit_support_callHelpParadrop;},{true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action_call_help_paradrop] call ace_interact_menu_fnc_addActionToObject;
};

if (isServer) then {
    [] spawn SPEC_fnc_rabbit_support_vehicleOnFire;
};