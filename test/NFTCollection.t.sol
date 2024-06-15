// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {NFTCollection} from "../src/NFTCollection.sol";
import {NFTGame} from "../src/NFTGame.sol";

contract NFTCollectionTest is Test {
  NFTCollection public nftCollection;
  NFTGame public nftGame;

  function setUp() public {
    nftCollection = new NFTCollection();
    nftGame = new NFTGame(nftCollection);
  }

  function testNFTCollectionMint() public {
    address Alice = address(1);
    vm.startPrank(Alice);
    nftCollection.mint(10);
    assertEq(nftCollection.balanceOf(Alice), 11);

    assertEq(nftGame.countTotalPrimeTokenIdByOwner(Alice), 5);
  }
}