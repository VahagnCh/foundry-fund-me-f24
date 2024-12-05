// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // us -> FundeMeTest -> FundMe
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }

    // What can we do to work with addresses outside our system?
    // 1. Unit Testing
    //  -Testing a specific part of our code in isolation
    // 2. Integration Testing
    //  -Testing how our code work with other parts of our code
    // 3. Forking
    //  -Testing our code in a simulated real environment
    // 4. Staging
    //  -Testing out code in a real enviroment that is not prod
    // forge coverage --rpc-url to review the test coverage

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

}
