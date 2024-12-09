// SPDX-License-Identifier: MIT

// Get funds from users 
// Withdraw funds
// Set a minimum funding value in USD

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded) private s_addressToAmountFunded; 

    uint256 public constant MINIMUN_USD = 5e18;
    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
       i_owner = msg.sender;
       s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {

        // Allow users to send money
        // Have a minimun money sent $5 USD
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUN_USD, "Didn't send enough ETH" ); // 1e18 = 1ETH = 1000000000000000000 = 1 * 10 ** 18
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
        //What is a revert?
        // Undo any action that have been done, and send the remaining gas back
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex ++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // Reset Array 
        s_funders = new address[](0);
        // Withdraw the funds
        // Transfer msg.sender = adress / payable(msg.adress) = payable adress
        // payable(msg.sender).transfer(address(this).balance);
        // Send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        // Call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");

    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // Executes the modifier first where we addit 
    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not owner");
        // _: means after the modifier execute the rest of the code
        // Using custom errors
        if(msg.sender != i_owner) {revert FundMe__NotOwner();}
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     * View / Pure functions (Getters)
     */

    function getAddressToAmountFunded(
        address fundingAdress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAdress];
    }

    function getFunders(uint256 index) external view returns (address) {
        return s_funders[index];
    }

}