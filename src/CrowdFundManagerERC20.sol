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

    mapping(uint256 => Fundraiser) public fundraisers;
    uint256 public fundraiserId;

    event FundraiserCreated(uint256 indexed fundraiserId, string name, uint256 goalAmount, uint256 deadline, address starter, address token);
    event DonationReceived(uint256 indexed fundraiserId, address donator, uint256 amount);
    event DonationWithdrawn(uint256 indexed fundraiserId, address donator, uint256 amount);

    function createFundraiser(string memory _name, uint256 _goalAmount, uint256 _deadline, IERC20 _token) public {
        require(_deadline > block.timestamp, "Deadline must be in the future");
        Fundraiser storage newFundraiser = fundraisers[fundraiserId];
        newFundraiser.fundraiserId = fundraiserId;
        newFundraiser.name = _name;
        newFundraiser.goalAmount = _goalAmount;
        newFundraiser.deadline = _deadline;
        newFundraiser.starter = msg.sender;
        newFundraiser.token = _token;

        emit FundraiserCreated(fundraiserId, _name, _goalAmount, _deadline, msg.sender, address(_token));
        fundraiserId++;
    }

    function donate(uint256 _fundraiserId, uint256 _amount) public {
        require(_amount > 0, "Donation must be greater than 0");
        require(fundraisers[_fundraiserId].deadline > block.timestamp, "Deadline has passed");

        Fundraiser storage fundraiser = fundraisers[_fundraiserId];
        fundraiser.currentAmount += _amount;
        fundraiser.donations[msg.sender] += _amount;
        fundraiser.token.transferFrom(msg.sender, address(this), _amount);

        emit DonationReceived(_fundraiserId, msg.sender, _amount);
    }

    function withdraw(uint256 _fundraiserId) public {
        Fundraiser storage fundraiser = fundraisers[_fundraiserId];

        if (block.timestamp <= fundraiser.deadline && fundraiser.currentAmount >= fundraiser.goalAmount) {
            require(msg.sender == fundraiser.starter, "Only starter can withdraw");

            uint256 amount = fundraiser.currentAmount;
            fundraiser.currentAmount = 0;
            fundraiser.token.transfer(fundraiser.starter, amount);

            emit DonationWithdrawn(_fundraiserId, msg.sender, amount);
        } else if (block.timestamp > fundraiser.deadline) {
            require(fundraiser.donations[msg.sender] > 0, "Only donators can withdraw");

            uint256 amount = fundraiser.donations[msg.sender];
            fundraiser.donations[msg.sender] = 0;
            fundraiser.token.transfer(msg.sender, amount);

            emit DonationWithdrawn(_fundraiserId, msg.sender, amount);
        }
    }


    function isDonator(uint256 _fundraiserId, address _donator) public view returns (bool) {
        return fundraisers[_fundraiserId].donations[_donator] > 0;
    }

}