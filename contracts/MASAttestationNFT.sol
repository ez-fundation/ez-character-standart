// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface ISymbeonVerifier {
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[2] memory input // [isCompliant, threshold]
    ) external view returns (bool);
}

/**
 * @title MASAttestationNFT
 * @dev Sovereign Attestation Credential based on GP-MAS consensus.
 */
contract MASAttestationNFT is ERC721, AccessControl {
    bytes32 public constant MOTHER_ORACLE_ROLE = keccak256("MOTHER_ORACLE_ROLE");
    ISymbeonVerifier public verifier;
    uint256 private _nextTokenId;

    event AttestationMinted(address indexed to, uint256 tokenId, uint256 threshold);

    constructor(
        string memory name, 
        string memory symbol, 
        address verifierAddress
    ) ERC721(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MOTHER_ORACLE_ROLE, msg.sender);
        verifier = ISymbeonVerifier(verifierAddress);
    }

    /**
     * @dev Mints an attestation NFT after on-chain ZK verification.
     */
    function mintAttestation(
        address to,
        uint256 threshold,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c
    ) public onlyRole(MOTHER_ORACLE_ROLE) {
        uint[2] memory publicInputs = [uint256(1), threshold];
        
        require(
            verifier.verifyProof(a, b, c, publicInputs), 
            "MAS: Cryptographic proof verification failed"
        );
        
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        
        emit AttestationMinted(to, tokenId, threshold);
    }

    function setVerifier(address verifierAddress) public onlyRole(DEFAULT_ADMIN_ROLE) {
        verifier = ISymbeonVerifier(verifierAddress);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
