// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFT is ERC721, ERC2981, Ownable2Step {  
    uint16 public constant ROYALTY_FEE = 2_500;
    uint16 public constant TOTAL_SUPPLY = 1_000;
    uint16 private _tokenIdCounter;
    uint256 public constant DISCOUNT_PRICE = 0.05 ether;
    uint256 public constant SALE_PRICE = 1 ether;

    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _discountAddresses;
    
    event OnSalePurchased(address indexed buyer, uint256 tokenId);
    event Purchased(address indexed buyer, uint256 tokenId);

    constructor(address royalty_, bytes32 merkleRoot_) ERC721("NFT Staking", "NFTS") Ownable(msg.sender) {
        transferOwnership(msg.sender);
        acceptOwnership();
        _setDefaultRoyalty(royalty_, ROYALTY_FEE);
        merkleRoot = merkleRoot_;
    }

    function onSaleMint(bytes32[] calldata proof, uint256 index, address buyer) external payable {
        // verify proof
        _isAccountOnDiscountList(proof, index, buyer);
        
        // check if buyer has already bought
        require(!BitMaps.get(_discountAddresses, index), "Buyer already bought");

        // update BitMap
        BitMaps.setTo(_discountAddresses, index, true);

        // mint a nft for buyer
        uint16 tokenId = _internalMint(buyer, DISCOUNT_PRICE);

        emit OnSalePurchased(buyer, tokenId);
    }

    function mint(address buyer) external payable {
        uint16 tokenId = _internalMint(buyer, SALE_PRICE);
        emit Purchased(buyer, tokenId);
    }

    function _internalMint(address buyer, uint256 salePrice) internal returns(uint16) {
        uint16 currentTokenId = _tokenIdCounter;

        // make sure supply not exceed total supply
        require(TOTAL_SUPPLY > currentTokenId, "Max supply reach");

        // check if buyer has enough to cover sale mint price
        require(msg.value == salePrice, "Not enough to buy");

        uint16 newTokenId = _tokenIdCounter++;
        // mint a nft for buyer
        _mint(buyer, newTokenId);

        return newTokenId;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    } 

    function _isAccountOnDiscountList(bytes32[] calldata proof, uint256 index, address buyer) internal {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(buyer, index))));
        require(MerkleProof.verify(proof, merkleRoot, leaf) == true, "buyer no on sale list");
    }
}
