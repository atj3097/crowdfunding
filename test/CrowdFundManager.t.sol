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

    function testFundraiserCreation() {
        crowdFundManager.createFundraiser("Test Fundraiser", 100, block.timestamp + 1000, address(0x1));
        Fundraiser memory fundraiser = crowdFundManager.fundraisers(0);
        assertEq(fundraiser.fundraiserId, 0);
        assertEq(fundraiser.name, "Test Fundraiser");
        assertEq(fundraiser.goalAmount, 100);
        assertEq(fundraiser.deadline, block.timestamp + 1000);
        assertEq(fundraiser.starter, address(this));
        assertEq(fundraiser.token, address(0x1));
    }


}