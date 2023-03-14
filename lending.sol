// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract P2PLendingPlatform {
    // Mapping from loan ID to loan info
    mapping (uint => Loan) public loans;

    // Struct to store loan info
    struct Loan {
        address lender;
        address borrower;
        uint amount;
        bool repaid;
    }

    // Function to create a loan listing
    function createLoanListing(uint amount) public payable {
        require(msg.value >= amount, "Insufficient funds for loan listing.");

        // Generate a unique ID for the loan
        uint id = uint(keccak256(abi.encodePacked(msg.sender, block.timestamp, amount)));

        // Set the loan info
        loans[id] = Loan({
            lender: msg.sender,
            borrower: address(0),
            amount: amount,
            repaid: false
        });
    }

    // Function for a user to take out a loan
    function takeOutLoan(uint id) public payable {
        require(loans[id].borrower == address(0), "Loan has already been taken out.");

        // Set the borrower for the loan
        loans[id].borrower = msg.sender;

        // Transfer the loan amount to the borrower
        payable(msg.sender).transfer(loans[id].amount);
    }

    // Function for a user to repay a loan
    function repayLoan(uint id) public payable {
        require(loans[id].borrower == msg.sender, "Sender is not the borrower of this loan.");
        require(msg.value >= loans[id].amount, "Insufficient funds to repay loan.");

        // Transfer the loan amount to the lender
        payable(loans[id].lender).transfer(loans[id].amount);

        // Set the repaid flag to true
        loans[id].repaid = true;
    }

    // Function to get the borrower for a loan
    function getBorrower(uint id) public view returns (address) {
        return loans[id].borrower;
    }

    // Function to get the repaid status for a loan
    function getRepaid(uint id) public view returns (bool) {
        return loans[id].repaid;
    }
}
