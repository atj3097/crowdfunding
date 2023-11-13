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





}