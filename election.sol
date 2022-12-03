pragma solidity ^0.5.0;

contract Election {
    // Mapping from candidate names to number of votes received
    mapping (string => uint) public votesReceived;

    // List of all candidate names
    string[] public candidates;

    // Flag to indicate if the election is still ongoing
    bool public electionOngoing = true;

    // Function to cast a vote for a candidate
    function vote(string memory candidate) public {
        require(electionOngoing, "Election is over.");
        require(votesReceived[candidate] != 0, "Invalid candidate.");
        votesReceived[candidate]++;
    }

    // Function to end the election
    function endElection() public {
        require(electionOngoing, "Election is already over.");
        electionOngoing = false;
    }

    // Function to get the winner of the election
    function getWinner() public view returns (string memory) {
        require(!electionOngoing, "Election is ongoing.");

        string memory winner;
        uint winningVotes = 0;

        // Find the candidate with the most votes
        for (uint i = 0; i < candidates.length; i++) {
            if (votesReceived[candidates[i]] > winningVotes) {
                winner = candidates[i];
                winningVotes = votesReceived[candidates[i]];
            }
        }

        return winner;
    }
}