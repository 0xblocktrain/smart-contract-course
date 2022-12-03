pragma solidity ^0.5.0;

contract Escrow {
    // Address of the escrow contract
    address public escrow;

    // Flag to indicate if the funds are locked in escrow
    bool public fundsLocked = true;

    // Function to deposit funds into the escrow contract
    function deposit() public payable {
        require(fundsLocked, "Funds are not locked in escrow.");
        require(msg.value > 0, "Must deposit a positive amount.");

        // Deposit the funds into the escrow contract
        escrow.transfer(msg.value);
    }

    // Function to release the funds from escrow
    function releaseFunds() public {
        require(fundsLocked, "Funds are not locked in escrow.");

        // Transfer the funds to the caller
        msg.sender.transfer(this.balance);

        // Set the fundsLocked flag to false
        fundsLocked = false;
    }
}
