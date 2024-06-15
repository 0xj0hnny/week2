// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {NFT} from "../src/NFT.sol";

contract NFTTest is Test {
  NFT public nft;
  address royaltyAddress = address(99);
  bytes32 merkleRoot = 0x897d6714686d83f84e94501e5d6f0f38c94b75381b88d1de3878b4f3d2d5014a;
  address Alice = address(1); // on onsale list

  function setUp() public {
    nft = new NFT(royaltyAddress, merkleRoot);
  }

  function testOnSaleMint() public {
    bytes32[] memory proof = new bytes32[](3);
    proof[0] = 0x50bca9edd621e0f97582fa25f616d475cabe2fd783c8117900e5fed83ec22a7c;
    proof[1] = 0x8138140fea4d27ef447a72f4fcbc1ebb518cca612ea0d392b695ead7f8c99ae6;
    proof[2] = 0x9005e06090901cdd6ef7853ac407a641787c28a78cb6327999fc51219ba3c880;
    uint256 index = 0;
    vm.deal(Alice, 1 ether);
    vm.prank(Alice);
    assertEq(address(Alice).balance, 1 ether);
    nft.onSaleMint{ value: 0.05 ether }(proof, index, Alice);
    assertEq(address(Alice).balance, 0.95 ether);

    address notOnSaleBuyer = address(3);
    uint256 wrongIndex = 10;
    vm.deal(notOnSaleBuyer, 1 ether);
    vm.prank(notOnSaleBuyer);
    assertEq(address(notOnSaleBuyer).balance, 1 ether);
    vm.expectRevert();
    nft.onSaleMint{ value: 0.05 ether }(proof, index, notOnSaleBuyer);
  }

  function testRegularSaleMint() public {
    address Bob = address(11);
    vm.deal(Bob, 1 ether);
    vm.startPrank(Bob);
    assertEq(address(Bob).balance, 1 ether);
    nft.mint{ value: 1 ether }(Bob);
    assertEq(address(Bob).balance, 0 ether);
  }

}