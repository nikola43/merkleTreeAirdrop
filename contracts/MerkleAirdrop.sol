// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop is Ownable {
    bytes32 public merkleRoot;
    uint256 public claimAmount;
    uint256 public totalClaimedAmount;
    uint256 public claimCounter;
    address public tokenAddress;

    mapping(address => bool) public claimed;

    event Claim(address indexed claimer, uint256 amount);

    // CONSTRUCTOR ------------------------------------------------------------------------------------------
    constructor(bytes32 _merkleRoot, address _tokenAddress, uint256 _amount) {
        merkleRoot = _merkleRoot;
        _tokenAddress = _tokenAddress;
        claimAmount = _amount;
    }

    // CONTRACT FUNCTIONS ------------------------------------------------------------------------------------
    function claim(bytes32[] calldata merkleProof) external {
        require(
            canClaim(msg.sender, merkleProof),
            "MerkleAirdrop: Address is not a candidate for claim"
        );

        // check if contract has enough tokens to send
        require(
            ERC20(tokenAddress).balanceOf(address(this)) >= claimAmount,
            "MerkleAirdrop: Contract has not enough tokens to send"
        );

        // transfer tokens to claimer
        ERC20(tokenAddress).transfer(msg.sender, claimAmount);

        // update claimed status
        claimed[msg.sender] = true;
        totalClaimedAmount += claimAmount;
        claimCounter++;
        
        emit Claim(msg.sender, claimAmount);
    }

    function updateTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function updateMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function canClaim(address claimer, bytes32[] calldata merkleProof)
        public
        view
        returns (bool)
    {
        return
            !claimed[claimer] &&
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(claimer))
            );
    }
}
