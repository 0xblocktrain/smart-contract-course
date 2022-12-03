pragma solidity ^0.5.0;

contract ReferralSystem {
    // Mapping from user addresses to their referral info
    mapping (address => Referral) public referrals;

    // Struct to store referral info
    struct Referral {
        address referrer;
        uint[] referred;
    }

    // Function to join the referral system
    function join(address referrer) public {
        require(referrals[msg.sender].referrer == address(0), "User has already joined the referral system.");

        // Set the user's referral info
        referrals[msg.sender] = Referral({
            referrer: referrer,
            referred: new uint[](0)
        });

        // Add the user to the referrer's list of referred users
        referrals[referrer].referred.push(msg.sender);
    }

    // Function to get the referrer of a user
    function getReferrer(address user) public view returns (address) {
        return referrals[user].referrer;
    }

    // Function to get the referred users of a user
    function getReferred(address user) public view returns (address[]) {
        return referrals[user].referred;
    }

    // Function to reward a user for making a referral
    function reward(address user) public payable {
        require(referrals[user].referrer != address(0), "User has not joined the referral system.");

        // Transfer the reward to the user
        user.transfer(msg.value);
    }
}
