// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {RewardToken} from "../src/RewardToken.sol";

contract RewardTokenTest is Test {
  RewardToken public rewardToken;

  function setUp() public {
    rewardToken = new RewardToken();
  }

  function testRewardTokenInfo() public view {
    assertEq(rewardToken.name(), "RewardToken");
    assertEq(rewardToken.symbol(), "RewardToken");
  }
}