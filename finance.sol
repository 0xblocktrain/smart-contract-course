pragma solidity ^0.5.0;

contract SupplyChainFinancePlatform {
    // Mapping from finance request ID to finance request info
    mapping (uint => FinanceRequest) public financeRequests;

    // Struct to store finance request info
    struct FinanceRequest {
        address borrower;
        uint amount;
        bool funded;
    }

    // Mapping from finance offer ID to finance offer info
    mapping (uint => FinanceOffer) public financeOffers;

    // Struct to store finance offer info
    struct FinanceOffer {
        address lender;
        uint amount;
        uint interestRate;
        bool funded;
    }

    // Function for a user to request financing for their supply chain activities
    function requestFinancing(uint amount) public {
        // Generate a unique ID for the finance request
        uint id = keccak256(abi.encodePacked(msg.sender, now, amount));

        // Set the finance request info
        financeRequests[id] = FinanceRequest({
            borrower: msg.sender,
            amount: amount,
            funded: false
        });
    }

    // Function for a user to offer financing for supply chain activities
    function offerFinancing(uint amount, uint interestRate) public {
        // Generate a unique ID for the finance offer
        uint id = keccak256(abi.encodePacked(msg.sender, now, amount, interestRate));

        // Set the finance offer info
        financeOffers[id] = FinanceOffer({
            lender: msg.sender,
            amount: amount,
            interestRate: interestRate,
            funded: false
        });
    }

    // Function for a user to fund a finance request
    function fundFinanceRequest(uint requestId, uint offerId) public {
        require(financeRequests[requestId].funded == false, "Finance request has already been funded.");
        require(financeOffers[offerId].funded == false, "Finance offer has already been funded.");
        require(financeRequests[requestId].amount <= financeOffers[offerId].amount, "Finance offer is not sufficient to fund finance request.");

        // Transfer the funds for the finance request to the borrower
        financeRequests[requestId].borrower.transfer(financeRequests[requestId].amount);

        // Set the funded flag for the finance request and offer to true
        financeRequests[requestId].funded = true;
        financeOffers[offerId].funded = true;
    }

    // Function to get the borrower for a finance request
    function getBorrower(uint id) public view returns (address) {
        return financeRequests[id].borrower;
    }
}
