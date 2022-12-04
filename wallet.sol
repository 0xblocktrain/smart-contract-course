// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Wallet {
    // Address of the wallet
    address public wallet;

    // Function to initialize the wallet
    function initialize() public {
        // Set the wallet address to the contract address
        wallet = address(this);
    }

    // Function to send Ether from the wallet
    function sendEther(address _to, uint _value) public {
        // Require the sender to be the wallet
        require(msg.sender == wallet, "Only the wallet can send Ether.");

        // Transfer the Ether
        _to.transfer(_value);
    }

    // Function to receive Ether to the wallet
    function receiveEther() public payable {
        // Require the receiver to be the wallet
        require(msg.sender == wallet, "Only the wallet can receive Ether.");
    }

    // Function to get the balance of the wallet
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
