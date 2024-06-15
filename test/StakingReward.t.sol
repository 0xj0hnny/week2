pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StakingReward} from "../src/StakingReward.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {NFT} from "../src/NFT.sol";

contract StakingRewardTest is Test {
  StakingReward public stakingReward;
  RewardToken public rewardToken;
  NFT public nft;

  address royaltyAddress = address(99);
  bytes32 merkleRoot = 0x897d6714686d83f84e94501e5d6f0f38c94b75381b88d1de3878b4f3d2d5014a;
  address nftDeployer = address(11); 
  address rewardTokenDeployer = address(20);
  address stakingRewardDeployer = address(30);

  function setUp() public {
    vm.prank(nftDeployer);
    nft = new NFT(royaltyAddress, merkleRoot);
    vm.prank(rewardTokenDeployer);
    rewardToken = new RewardToken();
    vm.prank(stakingRewardDeployer);
    stakingReward = new StakingReward(rewardToken, nft);

  }

  function testMintNftAndDeposit() public {
    address Alice = address(100);
    vm.deal(Alice, 1 ether);
    vm.startPrank(Alice);
    nft.mint{ value: 1 ether }(Alice);
    assertEq(nft.balanceOf(Alice), 1);
    vm.startPrank(address(nft));
    stakingReward.onERC721Received(address(nft), Alice, 1, "");
    assertEq(stakingReward.getStakeInfo(1).originalOwner, Alice);
    skip(block.timestamp + 1 days);
    // assertEq(rewardToken.totalSupply(), 10);
  }

}