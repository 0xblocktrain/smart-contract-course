pragma solidity ^0.5.0;

contract SubscriptionService {
    // Mapping from user addresses to subscription info
    mapping (address => Subscription) public subscriptions;

    // Struct to store subscription info
    struct Subscription {
        bool active;
        uint rate;
        uint nextPayment;
    }

    // Function to subscribe to the service
    function subscribe(uint rate) public {
        // Set the subscription info for the user
        subscriptions[msg.sender] = Subscription({
            active: true,
            rate: rate,
            nextPayment: now + 1 weeks
        });
    }

    // Function to unsubscribe from the service
    function unsubscribe() public {
        // Set the subscription to inactive
        subscriptions[msg.sender].active = false;
    }

    // Function to be called on a regular basis to process payments
    function processPayments() public {
        // Loop through all active subscriptions
        for (address user in subscriptions) {
            Subscription storage sub = subscriptions[user];

            // Check if it's time for the next payment
            if (sub.active && sub.nextPayment <= now) {
                // Charge the user's account
                user.transfer(sub.rate);

                // Update the next payment time
                sub.nextPayment = now + 1 weeks;
            }
        }
    }
}
