// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract RealEstatePlatform {
    // Mapping from property ID to property info
    mapping (uint => Property) public properties;

    // Struct to store property info
    struct Property {
        address owner;
        uint price;
        bool forSale;
    }

    // Function to list a property for sale
    function listProperty(uint id, uint price) public {
        require(properties[id].forSale == false, "Property is already for sale.");

        // Set the property info
        properties[id] = Property({
            owner: msg.sender,
            price: price,
            forSale: true
        });
    }

    // Function for a user to purchase a property
    function purchaseProperty(uint id) public payable {
        require(properties[id].forSale == true, "Property is not for sale.");
        require(msg.value >= properties[id].price, "Insufficient funds for property.");

        // Transfer the property ownership to the buyer
        properties[id].owner = msg.sender;

        // Transfer the purchase amount to the seller
        properties[id].owner.transfer(msg.value);

        // Set the forSale flag to false
        properties[id].forSale = false;
    }

    // Function to get the owner of a property
    function getOwner(uint id) public view returns (address) {
        return properties[id].owner;
    }

    // Function to get the sale status of a property
    function getForSale(uint id) public view returns (bool) {
        return properties[id].forSale;
    }
}
