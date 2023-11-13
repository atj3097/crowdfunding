// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/CrowdFundManager.sol";


contract CrowdFundManagerTest is Test {

    struct Fundraiser {
        uint256 fundraiserId;
        string name;
        uint256 goalAmount;
        uint256 currentAmount;
        uint256 deadline;
        address starter;
        address token;
        mapping (address => uint256) donations;
    }

    CrowdFundManager crowdFundManager;

    function setUp() public {
        crowdFundManager = new CrowdFundManager();
    }


}