// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract VotingSystem {
    // Mapping from candidate names to number of votes received
    mapping (string => uint) public votesReceived;

    // List of all candidate names
    string[] public candidates;

    // Flag to indicate if the voting is still ongoing
    bool public votingOngoing = true;

    // Event to be emitted when a vote is cast
    event VoteCast(address voter, string candidate);

    // Function to cast a vote for a candidate
    function vote(string memory candidate) public {
        require(votingOngoing, "Voting is over.");
        require(votesReceived[candidate] != 0, "Invalid candidate.");
        votesReceived[candidate]++;

        // Emit a VoteCast event
        emit VoteCast(msg.sender, candidate);
    }

    // Function to end the voting
    function endVoting() public {
        require(votingOngoing, "Voting is already over.");
        votingOngoing = false;
    }

    // Function to get the results of the voting
    function getResults() public view returns (string[] memory, uint[]) {
        require(!votingOngoing, "Voting is ongoing.");
        return (candidates, votesReceived);
    }
}
