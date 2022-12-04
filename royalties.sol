// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract RoyaltiesNFTs {
    // Address of the contract owner
    address public owner;

    // ERC721 contract for the NFTs
    ERC721 public nftContract;

    // Royalty percentage for the NFTs
    uint public royaltyPercentage;

    // Mapping from NFT ID to royalty recipient
    mapping (uint => address) public royaltyRecipients;

    // Function to initialize the contract
    function initialize(address _nftContract, uint _royaltyPercentage) public {
        // Set the contract owner to the msg.sender
        owner = msg.sender;

        // Set the ERC721 contract for the NFTs
        nftContract = ERC721(_nftContract);

        // Set the royalty percentage for the NFTs
        royaltyPercentage = _royaltyPercentage;
    }

    // Function to set the royalty recipient for a given NFT ID
    function setRoyaltyRecipient(uint _id, address _recipient) public {
        // Require the caller to be the contract owner
        require(msg.sender == owner, "Only the contract owner can set the royalty recipient.");

        // Set the royalty recipient for the NFT
        royaltyRecipients[_id] = _recipient;
    }

    // Function to buy an NFT
    function buyNFT(uint _id) public payable {
        // Get the NFT price
        uint price = nftContract.tokenMetadata(_id).price;

        // Calculate the royalty amount
        uint royaltyAmount = price * royaltyPercentage / 100;

        // Transfer the NFT to the buyer
        nftContract.safeTransferFrom(nftContract.ownerOf(_id), msg.sender, _id);

        // Transfer the royalty amount to the royalty recipient
        royaltyRecipients[_id].transfer(royaltyAmount);
    }
}
