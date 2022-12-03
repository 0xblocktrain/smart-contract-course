pragma solidity ^0.5.0;

contract DataMarketplace {
    // Mapping from data ID to data info
    mapping (uint => Data) public data;

    // Struct to store data info
    struct Data {
        address owner;
        uint price;
        bool forSale;
    }

    // Function for a user to list data for sale
    function listData(uint id, uint price) public {
        require(data[id].forSale == false, "Data is already for sale.");

        // Set the data info
        data[id] = Data({
            owner: msg.sender,
            price: price,
            forSale: true
        });
    }

    // Function for a user to purchase data
    function purchaseData(uint id) public payable {
        require(data[id].forSale == true, "Data is not for sale.");
        require(msg.value >= data[id].price, "Insufficient funds for data.");

        // Transfer the data ownership to the buyer
        data[id].owner = msg.sender;

        // Transfer the purchase amount to the seller
        data[id].owner.transfer(msg.value);

        // Set the forSale flag to false
        data[id].forSale = false;
    }

    // Function to get the owner of data
    function getOwner(uint id) public view returns (address) {
        return data[id].owner;
    }

    // Function to get the sale status of data
    function getForSale(uint id) public view returns (bool) {
        return data[id].forSale;
    }
}
