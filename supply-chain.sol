pragma solidity ^0.5.0;

contract SupplyChain {
    // Mapping from product IDs to product info
    mapping (uint => Product) public products;

    // Struct to store product info
    struct Product {
        address currentOwner;
        uint[] previousOwners;
        string[] history;
    }

    // Function to add a new product to the supply chain
    function addProduct(uint id, string memory historyItem) public {
        // Set the initial product info
        products[id] = Product({
            currentOwner: msg.sender,
            previousOwners: new uint[](0),
            history: new string[](1)
        });

        // Add the initial history item
        products[id].history[0] = historyItem;
    }

    // Function to transfer ownership of a product
    function transferProduct(uint id, address newOwner, string memory historyItem) public {
        // Ensure the caller is the current owner of the product
        require(products[id].currentOwner == msg.sender, "Only the current owner can transfer a product.");

        // Update the product info
        products[id].currentOwner = newOwner;
        products[id].previousOwners.push(msg.sender);
        products[id].history.push(historyItem);
    }

    // Function to get the current owner of a product
    function getCurrentOwner(uint id) public view returns (address) {
        return products[id].currentOwner;
    }

    // Function to get the previous owners of a product
    function getPreviousOwners(uint id) public view returns (uint[]) {
        return products[id].previousOwners;
    }

    // Function to get the history of a product
    function getHistory(uint id) public view returns (string[]) {
        return products[id].history;
    }
}
