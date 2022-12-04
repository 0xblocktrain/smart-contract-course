// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract InsuranceSystem {
    // Mapping from policy ID to policy info
    mapping (uint => Policy) public policies;

    // Struct to store policy info
    struct Policy {
        address owner;
        bool active;
        uint coverage;
    }

    // Mapping from claim ID to claim info
    mapping (uint => Claim) public claims;

    // Struct to store claim info
    struct Claim {
        address policyOwner;
        uint policyCoverage;
        uint amount;
        bool approved;
    }

    // Function to purchase a policy
    function purchasePolicy(uint id, uint coverage) public payable {
        require(policies[id].active == false, "Policy already exists.");
        require(coverage > 0, "Coverage must be greater than zero.");
        require(msg.value >= coverage, "Insufficient funds for policy.");

        // Set the policy info
        policies[id] = Policy({
            owner: msg.sender,
            active: true,
            coverage: coverage
        });
    }

    // Function to make a claim on a policy
    function makeClaim(uint id, uint claimAmount) public {
        require(policies[id].active == true, "Policy does not exist.");
        require(claimAmount <= policies[id].coverage, "Claim amount exceeds policy coverage.");

        // Set the claim info
        claims[id] = Claim({
            policyOwner: policies[id].owner,
            policyCoverage: policies[id].coverage,
            amount: claimAmount,
            approved: false
        });
    }

    // Function for the insurer to review and approve a claim
    function approveClaim(uint id) public {
        require(policies[id].active == true, "Policy does not exist.");
        require(claims[id].approved == false, "Claim has already been approved.");

        // Set the approved flag to true
        claims[id].approved = true;

        // Transfer the claim amount to the policy owner
        claims[id].policyOwner.transfer(claims[id].amount);
    }

    // Function to get the coverage amount for a policy
    function getCoverage(uint id) public view returns (uint) {
        return policies[id].coverage;
    }
}
