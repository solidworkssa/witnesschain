// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WitnessChain {
    struct Attestation {
        address attestor;
        bytes32 documentHash;
        string metadata;
        uint256 timestamp;
        address[] witnesses;
    }

    mapping(uint256 => Attestation) public attestations;
    mapping(uint256 => mapping(address => bool)) public hasWitnessed;
    uint256 public attestationCounter;

    event AttestationCreated(uint256 indexed attestationId, address indexed attestor);
    event WitnessAdded(uint256 indexed attestationId, address indexed witness);

    function createAttestation(bytes32 documentHash, string memory metadata) external returns (uint256) {
        uint256 attestationId = attestationCounter++;
        attestations[attestationId] = Attestation(
            msg.sender,
            documentHash,
            metadata,
            block.timestamp,
            new address[](0)
        );
        emit AttestationCreated(attestationId, msg.sender);
        return attestationId;
    }

    function addWitness(uint256 attestationId) external {
        if (!hasWitnessed[attestationId][msg.sender]) {
            attestations[attestationId].witnesses.push(msg.sender);
            hasWitnessed[attestationId][msg.sender] = true;
            emit WitnessAdded(attestationId, msg.sender);
        }
    }

    function getAttestation(uint256 attestationId) external view returns (Attestation memory) {
        return attestations[attestationId];
    }

    function verifyDocument(uint256 attestationId, bytes32 documentHash) external view returns (bool) {
        return attestations[attestationId].documentHash == documentHash;
    }
}
