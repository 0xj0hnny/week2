// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract NFTGame {
  IERC721Enumerable immutable nftCollection;

  constructor(IERC721Enumerable _nftCollection) {
    nftCollection = _nftCollection;
  }

  function isPrime(uint8 number) public pure returns (uint8) {
        if (number <= 1) {
            return 0;
        }
        if (number == 2) {
            return 1;
        }
        if (number % 2 == 0) {
            return 0;
        }
        for (uint8 i = 3; i * i <= number; i += 2) {
            if (number % i == 0) {
                return 0;
            }
        }
        return 1;
    }

  function countTotalPrimeTokenIdByOwner(address account) external view returns (uint8 totalPrimeCount) {
    uint8 numNftOwned = uint8(nftCollection.balanceOf(account));
    
    for (uint8 i = 0; i < numNftOwned; ) {
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