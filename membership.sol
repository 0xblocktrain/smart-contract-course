// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MembershipSystem {
    // Mapping from user addresses to their membership info
    mapping (address => Membership) public memberships;

    // Struct to store membership info
    struct Membership {
        bool active;
        uint[] perks;
    }

    // Function to join the membership system
    function join() public {
        require(!memberships[msg.sender].active, "Member has already joined.");

        // Set the member's membership info
        memberships[msg.sender] = Membership({
            active: true,
            perks: new uint[](0)
        });
    }

    // Function to add a perk to a member's membership
    function addPerk(address member, uint perk) public {
        require(memberships[member].active, "Member is not active.");

        // Add the perk to the member's perks
        memberships[member].perks.push(perk);
    }

    // Function to get the perks of a member's membership
    function getPerks(address member) public view returns (uint[]) {
        return memberships[member].perks;
    }
}
