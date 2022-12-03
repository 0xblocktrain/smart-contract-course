pragma solidity ^0.5.0;

contract Fundraiser {
    // Address of the fundraiser owner
    address public owner;

    // Total amount of funds raised
    uint public fundsRaised;

    // Flag to indicate if the fundraiser is still ongoing
    bool public fundraiserOngoing = true;

    // Event to be emitted when a contribution is made
    event Contribution(address contributor, uint amount);

    // Constructor to set the owner of the fundraiser
    constructor() public {
        owner = msg.sender;
    }

    // Function to contribute funds to the fundraiser
    function contribute() public payable {
        require(fundraiserOngoing, "Fundraiser is over.");

        // Increment the fundsRaised by the amount contributed
        fundsRaised += msg.value;

        // Emit a Contribution event
        emit Contribution(msg.sender, msg.value);
    }

    // Function to end the fundraiser and send the funds to the owner
    function endFundraiser() public {
        require(fundraiserOngoing, "Fundraiser is already over.");
        require(msg.sender == owner, "Only the owner can end the fundraiser.");

        // Send the funds to the owner
        owner.transfer(fundsRaised);

        // Set the fundraiserOngoing flag to false
        fundraiserOngoing = false;
    }
}
