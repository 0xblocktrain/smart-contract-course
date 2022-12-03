pragma solidity ^0.5.0;

contract IdentityVerificationService {
    // Mapping from user address to verification status
    mapping (address => bool) public verifications;

    // Function for a user to verify their identity
    function verifyIdentity() public {
        // Set the user's verification status to true
        verifications[msg.sender] = true;
    }

    // Function to check the verification status of a user
    function checkVerification(address user) public view returns (bool) {
        return verifications[user];
    }
}
