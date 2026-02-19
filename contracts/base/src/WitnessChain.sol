// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WitnessChain Contract
/// @author solidworkssa
/// @notice Digital notary and witness verification.
contract WitnessChain {
    string public constant VERSION = "1.0.0";


    struct Record {
        bytes32 hash;
        address witness;
        uint256 timestamp;
    }
    
    mapping(bytes32 => Record) public records;
    
    function notarize(bytes32 _hash) external {
        require(records[_hash].timestamp == 0, "Already notarized");
        records[_hash] = Record({
            hash: _hash,
            witness: msg.sender,
            timestamp: block.timestamp
        });
    }

}
