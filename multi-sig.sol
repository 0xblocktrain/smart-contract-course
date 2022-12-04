// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSigWallet {
    // Address of the wallet
    address public wallet;

    // Array of authorized signers for the wallet
    address[] public signers;

    // Array of signatures for a transaction
    bytes32[] public signatures;

    // Array of transaction IDs
    uint[] public transactions;

    // Struct to store transaction info
    struct Transaction {
        address to;
        uint value;
        bytes data;
    }

    // Mapping from transaction ID to transaction info
    mapping (uint => Transaction) public transactionInfo;

    // Function to initialize the wallet
    function initialize(address[] memory _signers) public {
        // Set the wallet address to the contract address
        wallet = address(this);

        // Set the authorized signers for the wallet
        signers = _signers;
    }

    // Function to submit a transaction for approval
    function submitTransaction(address _to, uint _value, bytes _data) public {
        // Generate a unique ID for the transaction
        uint id = keccak256(abi.encodePacked(_to, _value, _data));

        // Add the transaction to the transactions array
        transactions.push(id);

        // Set the transaction info
        transactionInfo[id] = Transaction({
            to: _to,
            value: _value,
            data: _data
        });
    }

    // Function for a signer to sign a transaction
    function signTransaction(uint _id) public {
        require(signatures[_id].length < signers.length, "Transaction already has enough signatures.");

        // Add the signer's signature to the signatures array
        signatures[_id].push(keccak256(abi.encodePacked(msg.sender, _id)));
    }

    // Function to execute a transaction
    function executeTransaction(uint _id) public {
        // Count the number of signatures for the transaction
        uint count = 0;
        for (uint i = 0; i < signatures[_id].length; i++) {
            if (signatures[_id][i] != 0) {
                count += 1;
            }
        }

        // Require the number of signatures to be greater than or equal to the number of signers
        require(count >= signers.length, "Transaction does not have enough signatures.");

        // Get the transaction info
        address to = transactionInfo[_id].to;
        uint value = transactionInfo[_id].value;
        bytes memory data = transactionInfo[_id].data;

        // Execute the transaction
        if (data.length == 0) {
            // Execute a regular transfer if the data field is empty
            to.transfer(value);
        } else {
            // Execute a contract call if the data field is not empty
            (bool success, bytes memory result) = to.call(data);
            require(success, "Error executing contract call.");
        }
    }
}