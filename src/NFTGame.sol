// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract NFTGame {
  IERC721Enumerable immutable nftCollection;

  constructor(IERC721Enumerable _nftCollection) {
      nftCollection = _nftCollection;
  }

  function isPrime(uint8 tokenId) internal pure returns (uint8 isPrimeNumber) {
    if (tokenId < 1 || tokenId > 100) isPrimeNumber = 0;
    if (tokenId <= 3) isPrimeNumber = 1;
    if (tokenId % 2 == 0 || tokenId % 3 == 0) isPrimeNumber = 0;
    for (uint8 i = 5; i <= tokenId;) {
      if (tokenId % i == 0 || tokenId % (i + 2) == 0) isPrimeNumber = 0;
      unchecked {
        i += 6;
      }
    }
    isPrimeNumber = 1;
  }

  function countTotalPrimeTokenIdByOwner(address account) external view returns (uint8 totalPrimeCount) {
    uint8 numNftOwned = uint8(nftCollection.balanceOf(account));
    
    for (uint8 i = 0; i <= numNftOwned; ) {
      uint256 tokenId = nftCollection.tokenOfOwnerByIndex(account, i);

      unchecked {
        if (isPrime(uint8(tokenId)) == 1) {
          totalPrimeCount++;
        }
        i++;
      }

    }
  }
}