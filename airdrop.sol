// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract AirdropNFTs {
    // Address of the contract owner
    address public owner;

    // ERC721 contract for the NFTs
    ERC721 public nftContract;

    // Array of user addresses
    address[] public users;

    // Function to initialize the contract
    function initialize(address _nftContract, address[] memory _users) public {
        // Set the contract owner to the msg.sender
        owner = msg.sender;

        // Set the ERC721 contract for the NFTs
        nftContract = ERC721(_nftContract);

        // Set the user addresses
        users = _users;
    }

    // Function to airdrop the NFTs to the users
    function airdrop() public {
        // Iterate over the users and airdrop the NFTs to them
        for (uint i = 0; i < users.length; i++) {
            // Mint a new NFT for the user
            nftContract.mint(users[i]);

            // Transfer the NFT to the user
            nftContract.safeTransferFrom(owner, users[i], nftContract.totalSupply() - 1);
        }
    }
}
