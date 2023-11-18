// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CrowdFundManager {

    event FundraiserCreated(uint256 indexed fundraiserId, string name, uint256 goalAmount, uint256 deadline, address starter, address token);
    event DonationReceived(uint256 indexed fundraiserId, address donator, uint256 amount);
    event DonationWithdrawn(uint256 indexed fundraiserId, address donator, uint256 amount);

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

    mapping(uint256 => Fundraiser) public fundraisers;
    uint256 public fundraiserId;

    function createFundraiser(string memory _name, uint256 _goalAmount, uint256 _deadline, address _token) public {
        require(_deadline > block.timestamp, "Deadline must be in the future");
        Fundraiser storage newFundraiser = fundraisers[fundraiserId];
        newFundraiser.fundraiserId = fundraiserId;
        newFundraiser.name = _name;
        newFundraiser.goalAmount = _goalAmount;
        newFundraiser.deadline = _deadline;
        newFundraiser.starter = msg.sender;
        newFundraiser.token = _token;

        emit FundraiserCreated(fundraiserId, _name, _goalAmount, _deadline, msg.sender, _token);
        fundraiserId++;
    }

    function donate(uint256 _fundraiserId) public payable {
        require(msg.value > 0, "Donation must be greater than 0");
        require(fundraisers[_fundraiserId].deadline > block.timestamp, "Deadline has passed");

        Fundraiser storage fundraiser = fundraisers[_fundraiserId];
        fundraiser.currentAmount += msg.value;
        fundraiser.donations[msg.sender] += msg.value;

        emit DonationReceived(_fundraiserId, msg.sender, msg.value);
    }

    function withdraw(uint256 _fundraiserId) public returns(bool) {
        Fundraiser storage fundraiser = fundraisers[_fundraiserId];

        if (block.timestamp <= fundraiser.deadline && fundraiser.currentAmount >= fundraiser.goalAmount) {
            require(msg.sender == fundraiser.starter, "Only starter can withdraw");

            uint256 amount = fundraiser.currentAmount;
            fundraiser.currentAmount = 0;
            payable(fundraiser.starter).transfer(amount);

            emit DonationWithdrawn(_fundraiserId, msg.sender, amount);
            return true;

        } else if (block.timestamp > fundraiser.deadline) {
            uint256 donorAmount = fundraiser.donations[msg.sender];
            require(donorAmount > 0, "No donations to withdraw");

            fundraiser.donations[msg.sender] = 0;
            payable(msg.sender).transfer(donorAmount);

            emit DonationWithdrawn(_fundraiserId, msg.sender, donorAmount);
            return true;
        }
        return false;
    }

    function isDonator(uint256 _fundraiserId, address _potentialDonator) public view returns(bool) {
        return fundraisers[_fundraiserId].donations[_potentialDonator] > 0;
    }
}
