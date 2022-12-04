// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ECommercePlatform {
    // Mapping from product ID to product info
    mapping (uint => Product) public products;

    // Struct to store product info
    struct Product {
        address owner;
        string name;
        uint price;
        bool forSale;
    }

    // Function for a user to list a product for sale
    function listProduct(uint id, string memory name, uint price) public {
        require(products[id].forSale == false, "Product is already for sale.");

        // Set the product info
        products[id] = Product({
            owner: msg.sender,
            name: name,
            price: price,
            forSale: true
        });
    }

    // Function for a user to purchase a product
    function purchaseProduct(uint id) public payable {
        require(products[id].forSale == true, "Product is not for sale.");
        require(msg.value >= products[id].price, "Insufficient funds for product.");

        // Transfer the product ownership to the buyer
        products[id].owner = msg.sender;

        // Transfer the purchase amount to the seller
        products[id].owner.transfer(msg.value);

        // Set the forSale flag to false
        products[id].forSale = false;
    }

    // Function to get the owner of a product
    function getOwner(uint id) public view returns (address) {
        return products[id].owner;
    }

    // Function to get the sale status of a product
    function getForSale(uint id) public view returns (bool) {
        return products[id].forSale;
    }
}
