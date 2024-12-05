// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";


contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        
        //Before startBroadcast will not be sent as a real transaction
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        // Mock
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast ();
        return fundMe;
    }
}