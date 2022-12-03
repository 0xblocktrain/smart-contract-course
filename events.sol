pragma solidity ^0.5.0;

contract EventTicketingService {
    // Mapping from event ID to event info
    mapping (uint => Event) public events;

    // Struct to store event info
    struct Event {
        address owner;
        uint ticketPrice;
        uint ticketTotal;
        uint ticketAvailable;
    }

    // Function for an event organizer to create an event
    function createEvent(uint ticketPrice, uint ticketTotal) public {
        // Generate a unique ID for the event
        uint id = keccak256(abi.encodePacked(msg.sender, now, ticketPrice, ticketTotal));

        // Set the event info
        events[id] = Event({
            owner: msg.sender,
            ticketPrice: ticketPrice,
            ticketTotal: ticketTotal,
            ticketAvailable: ticketTotal
        });
    }

    // Function for a user to purchase a ticket for an event
    function purchaseTicket(uint id) public payable {
        require(events[id].ticketAvailable > 0, "No tickets available for event.");
        require(msg.value >= events[id].ticketPrice, "Insufficient funds for ticket.");

        // Decrement the number of available tickets for the event
        events[id].ticketAvailable -= 1;

        // Transfer the ticket payment to the event owner
        events[id].owner.transfer(msg.value);
    }

    // Function to get the number of available tickets for an event
    function getTicketAvailability(uint id) public view returns (uint) {
        return events[id].ticketAvailable;
    }

    // Function to get the owner of an event
    function getOwner(uint id) public view returns (address) {
        return events[id].owner;
    }
}
