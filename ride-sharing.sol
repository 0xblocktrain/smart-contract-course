pragma solidity ^0.5.0;

contract RideSharingService {
    // Mapping from ride ID to ride info
    mapping (uint => Ride) public rides;

    // Struct to store ride info
    struct Ride {
        address owner;
        address[] passengers;
        uint[] passengerPayments;
        uint price;
    }

    // Function to offer a ride
    function offerRide(uint price) public {
        // Generate a unique ID for the ride
        uint id = keccak256(abi.encodePacked(msg.sender, now, price));

        // Set the ride info
        rides[id] = Ride({
            owner: msg.sender,
            passengers: new address[](0),
            passengerPayments: new uint[](0),
            price: price
        });
    }

    // Function for a user to request a ride
    function requestRide(uint id) public payable {
        require(rides[id].owner != msg.sender, "Cannot request own ride.");
        require(msg.value >= rides[id].price, "Insufficient funds for ride.");

        // Add the user as a passenger on the ride
        rides[id].passengers.push(msg.sender);

        // Add the payment to the ride's passenger payments
        rides[id].passengerPayments.push(msg.value);

        // Transfer the payment to the ride owner
        rides[id].owner.transfer(msg.value);
    }

    // Function to get the passengers for a ride
    function getPassengers(uint id) public view returns (address[]) {
        return rides[id].passengers;
    }
}
