// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCollection is ERC721Enumerable, Ownable2Step {
  uint8 public constant MAX_SUPPLY = 100;
  uint8 private tokenIdCount = 1;

  constructor() ERC721("NFT Collection", "NFTC") Ownable(msg.sender) {
    transferOwnership(msg.sender);
    acceptOwnership();
  }

  function mint(uint8 numOfTokensToMint) external {
    require(MAX_SUPPLY > tokenIdCount, "exceed max supply");
    uint8 startingTokenId = tokenIdCount;
    uint8 lastTokenId = startingTokenId + numOfTokensToMint;
    for (startingTokenId; startingTokenId <= lastTokenId; ) {
      _mint(msg.sender, startingTokenId);
      unchecked {
        startingTokenId++;
      }
    }
    tokenIdCount = lastTokenId;
  }
}
