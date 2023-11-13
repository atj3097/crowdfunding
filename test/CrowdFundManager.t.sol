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
        crowdFundManager.createFundraiser("Test Fundraiser", 100, block.timestamp + 1000, address(0x1));

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

    function testWithdraw() public {
        (uint256 fundraiserId,
            string memory name,
            uint256 goalAmount,
            uint256 currentAmount,
            uint256 deadline,
            address starter, address token) = crowdFundManager.fundraisers(0);

        crowdFundManager.donate{value: 100}(fundraiserId);
        crowdFundManager.withdraw(fundraiserId);
        assertEq(currentAmount, 0);
    }


}