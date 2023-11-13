// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
Crowdfunding ERC20 contract
Your contract should have a createFundraiser() function with a goal and a deadline as arguments. Donators can donate() to a given fundraiserId.
If the goal is reached before the deadline, the wallet that called createFundraiser() Can withdraw() all the funds associated with that campaign.
Otherwise, if the deadline passes without reaching the goal, the donators can withdraw their donation.
Build a contract that supports Ether and another that supports ERC20 tokens.

Some corner cases to think about:
what if the same address donates multiple times?
what if the same address donates to multiple different campaigns?
*/


contract CrowdFundManager {

    struct Fundraiser {
        uint256 fundraiserId;
        string name;
        uint256 goalAmount;
        uint256 currentAmount;
        uint256 deadline;
        address starter;
        address token;
        Donator[] donators;
    }

    struct Donator {
        uint256 fundraiserId;
        address donator;
        uint256 amount;
    }

    uint256 public totalEthDeposits;
    mapping (address => Donator) public ethDonations;

    mapping(uint256 => Fundraiser) public fundraisers;
    uint256 public fundraiserId;

    function createFundraiser(string memory name,
        uint256 goalAmount,
        uint256 deadline,
        address token) {
        require(deadline > block.timestamp, "deadline must be in the future");
        Donator memory donator = Donator(fundraiserId, msg.sender, 0);
        fundraisers[fundraiserId] = Fundraiser(fundraiserId, name, goalAmount, 0, deadline, msg.sender, token, [donator]);
        fundraiserId++;
    }

    function donate(uint256 _fundraiserId) payable {
        require(msg.value > 0, "donation must be greater than 0");
        require(fundraisers[_fundraiserId].deadline < block.timestamp, "deadline has passed");
        Fundraiser storage fundraiser = fundraisers[_fundraiserId];
        totalEthDeposits += msg.value;
        ethDeposits[msg.sender] = Donator(_fundraiserId, msg.sender, msg.value);
    }

    function withdraw(uint256 _fundraiserId) {
        if (fundraisers[_fundraiserId].deadline > block.timestamp && fundraisers[_fundraiserId].goalAmount >= fundraisers[_fundraiserId].currentAmount) {
            require(msg.sender == fundraisers[_fundraiserId].starter, "only start can withdraw");
            address payable recipient = payable(fundraisers[_fundraiserId].starter);
            (bool success, ) = recipient.call{value: fundraisers[_fundraiserId].currentAmount}("");
            require(success, "Transfer failed.");
            totalEthDeposits -= fundraisers[_fundraiserId].currentAmount;
        } else {
            if (isDonator(_fundraiserId, msg.sender)) {
                address payable recipient = payable(msg.sender);
                (bool success, ) = recipient.call{value: ethDeposits[msg.sender].amount}("");
                require(success, "Transfer failed.");
                totalEthDeposits -= ethDeposits[msg.sender].amount;
                ethDeposits[msg.sender] = 0;
            }

        }
    }

    function isDonator(uint256 _fundraiserId, address potentialDonator) public returns(bool)
        for (uint i = 0; i < fundraisers[_fundraiserId].donators.length; i++) {
            if (fundraisers[_fundraiserId].donators[i] == potentialDonator) {
                return true;
            }
            else {
                return false;
            }
        }
    }





}