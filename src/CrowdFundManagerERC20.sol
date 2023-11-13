// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CrowdFundManagerERC20 {

    struct Fundraiser {
        uint256 fundraiserId;
        string name;
        uint256 goalAmount;
        uint256 currentAmount;
        uint256 deadline;
        address starter;
        IERC20 token;
        mapping (address => uint256) donations;
    }



}