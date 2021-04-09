class cbps_deploy {
  file = "spec_cbps_deploy\fnc";

  class cbps_deploy_handleVehicleSpawn {};

  class cbps_deploy_isCBPS {};

  class cbps_deploy_preInit {
      preInit = 1;
  };

  class cbps_deploy_postInit {
      postInit = 1;
  };
};

class cbps_deploy_btc_hm {
    file = "spec_cbps_deploy\fnc\BTC_HM";

    class cbps_deploy_btc_hm_init {};
    class cbps_deploy_btc_hm_handleCBPSEvent {};
    class cbps_deploy_btc_hm_createFob {};
    class cbps_deploy_btc_hm_createFobSave {};
    class cbps_deploy_btc_hm_fobInit {};
    class cbps_deploy_btc_hm_fobKilled {};
}
