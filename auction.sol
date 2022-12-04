// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Auction {
    // Address of the auction owner
    address public owner;

    // The item being auctioned off
    string public item;

    // Current highest bid for the item
    Bid public highestBid;

    // Struct to store bid info
    struct Bid {
        address bidder;
        uint amount;
    }

    // Flag to indicate if the auction is still ongoing
    bool public auctionOngoing = true;

    // Event to be emitted when a new bid is made
    event NewBid(address bidder, uint amount);

    // Constructor to set the owner and item for the auction
    constructor(string memory _item) public {
        owner = msg.sender;
        item = _item;
    }

    // Function to bid on the item
    function bid() public payable {
        require(auctionOngoing, "Auction is over.");
        require(msg.value > highestBid.amount, "Bid amount must be higher than the current highest bid.");

        // Set the new highest bid
        highestBid = Bid({
            bidder: msg.sender,
            amount: msg.value
        });

        // Emit a NewBid event
        emit NewBid(msg.sender, msg.value);
    }

    // Function to end the auction and award the item to the highest bidder
    function endAuction() public {
        require(auctionOngoing, "Auction is already over.");
        require(msg.sender == owner, "Only the owner can end the auction.");

        // Send the funds to the highest bidder
        highestBid.bidder.transfer(highestBid.amount);

        // Set the auctionOngoing flag to false
        auctionOngoing = false;
    }
}
