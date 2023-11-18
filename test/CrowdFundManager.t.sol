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
    uint256 fundraiserId;

    function setUp() public {
        crowdFundManager = new CrowdFundManager();
        vm.prank(address(0x1));
        crowdFundManager.createFundraiser("Test Fundraiser", 100, block.timestamp + 1000, address(this));

    }

    function testFundraiserCreation() public {
        (uint256 fundraiserId,
            string memory name,
            uint256 goalAmount,
            uint256 currentAmount,
            uint256 deadline,
            address starter, address token) = crowdFundManager.fundraisers(0);
        assertEq(fundraiserId, 0);
        assertEq(name, "Test Fundraiser");
        assertEq(goalAmount, 100);
        assertEq(deadline, block.timestamp + 1000);
        assertEq(starter, address(this));
        assertEq(token, address(0x1));
    }

    function testDonation() public {
        (uint256 fundraiserId,
            string memory name,
            uint256 goalAmount,
            uint256 currentAmount,
            uint256 deadline,
            address starter, address token) = crowdFundManager.fundraisers(0);

        crowdFundManager.donate{value: 50}(fundraiserId);
        assertEq(currentAmount, 50);
    }

    //TODO: Fix this test
//    function testWithdraw() public {
//        // Fetch fundraiserId and starter before donation
//        (uint256 fundraiserId,, , , , address starter, ) = crowdFundManager.fundraisers(0);
//
//        // Make a donation
//        vm.prank(starter);
//        crowdFundManager.donate{value: 100}(fundraiserId);
//
//        // Warp time to exceed the deadline
//        vm.warp(block.timestamp + 1001);
//
//        // Impersonate the starter and withdraw
//        vm.prank(starter);
//        bool success = crowdFundManager.withdraw(fundraiserId);
//        assertEq(success, true);
//
//        // Fetch the updated current amount
//        (, , , uint256 newCurrentAmount, , , ) = crowdFundManager.fundraisers(0);
//        assertEq(newCurrentAmount, 0);
//    }



}