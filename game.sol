// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Game {
    // Address of the game owner
    address public owner;

    // Mapping from player addresses to their game state
    mapping (address => Player) public players;

    // Struct to store player game state
    struct Player {
        bool active;
        uint score;
    }

    // Flag to indicate if the game is still ongoing
    bool public gameOngoing = true;

    // Event to be emitted when a player's score is updated
    event ScoreUpdated(address player, uint score);

    // Constructor to set the game owner
    constructor() public {
        owner = msg.sender;
    }

    // Function to join the game
    function joinGame() public {
        require(gameOngoing, "Game is over.");
        require(!players[msg.sender].active, "Player has already joined the game.");

        // Set the player's game state
        players[msg.sender] = Player({
            active: true,
            score: 0
        });
    }

    // Function to play the game
    function play() public {
        require(gameOngoing, "Game is over.");
        require(players[msg.sender].active, "Player has not joined the game.");

        // Update the player's score
        players[msg.sender].score++;

        // Emit a ScoreUpdated event
        emit ScoreUpdated(msg.sender, players[msg.sender].score);
    }

    // Function to end the game and determine the winner
    function endGame() public {
        require(gameOngoing, "Game is already over.");
        require(msg.sender == owner, "Only the owner can end the game.");

        // Set the gameOngoing flag to false
        gameOngoing = false;

        // Determine the winner
        address winner;
        uint maxScore = 0;
        for (address player in players) {
            if (players[player].score > maxScore) {
                winner = player;
                maxScore = players[player].score;
            }
        }

        // Award the winner
        winner.transfer(this.balance);
    }
}