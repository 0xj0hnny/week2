// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {Ownable2Step} from  "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RewardToken} from './RewardToken.sol';

contract StakingReward is IERC721Receiver, Ownable2Step {
    IERC721 internal immutable nft;
    RewardToken internal rewardToken;

    uint8 constant private DAILY_REWARD = 10;
    uint32 constant private SECONDS_PER_DAY = 60 * 60 * 24;
    uint32 private _lastRewardBlockTime;
    uint256 private _totalStakingReward;

    struct Stake {
        uint32 stakedAt;
        address originalOwner;
    }

    mapping(uint256 id => Stake stake) public stakes;

    event NftDeposited(address indexed originalOwner, uint256 id);
    event WithdrawNftSaleByOwner();
    event WithdrwNftByOwner(address indexed withdrawer, uint256 id);
    event TotalStakingRewardUpdated();
    event ClaimStakingReward(address indexed originalOwner, uint256 id, uint256 amount);

    constructor(RewardToken _rewardToken, IERC721 _nft) Ownable(msg.sender) {
        rewardToken = _rewardToken;
        nft = _nft;
        acceptOwnership();
    }

    function onERC721Received(
        address operator, 
        address from, 
        uint256 id, 
        bytes calldata data
    ) external override returns (bytes4) {
        require(msg.sender == address(nft), "wrong nft address");

        stakes[id] = Stake({ 
            stakedAt: uint32(block.timestamp), 
            originalOwner: from
        });
        _updateTotalStakingReward();
        emit NftDeposited(from, id);
        return IERC721Receiver.onERC721Received.selector;
    }

    function claimStakingRewardByNftOwner(uint256 id) external _isNftStaked(id) {
        uint256 reward = pendingReward(id);

        if (reward > 0) {
            rewardToken.transferFrom(address(this), msg.sender, reward * 10 ** 18);
            _totalStakingReward -= reward;
        }

         emit ClaimStakingReward(msg.sender, id, reward * 10 ** 18);
    }

    function withdrawNftByOwner(uint256 id) external _isNftStaked(id) {

        // transfer NFT back to the original owner
        nft.safeTransferFrom(address(this), msg.sender, id);

        // delete the one in the mapping
        delete stakes[id];

        uint256 reward = pendingReward(id);

        if (reward > 0) {
            rewardToken.transferFrom(address(this), msg.sender, reward * 10 ** 18);
        }

        // emit event 
        emit ClaimStakingReward(msg.sender, id, reward * 10 ** 18);
        emit WithdrwNftByOwner(msg.sender, id);
    }

    function withdrwarNftSaleByOwner() external onlyOwner {
        (bool success, ) = owner().call{value: address(nft).balance}("");
        require(success, "fail to withdraw nft sale");
        emit WithdrawNftSaleByOwner();
    } 

    function pendingReward(uint256 id) internal view returns (uint256 stakingReward) {
        Stake memory existingStake = stakes[id];
        uint32 stakeDuration = uint32(block.timestamp) - existingStake.stakedAt;
        if (stakeDuration < SECONDS_PER_DAY) {
            stakingReward = 0;
        } else {
            stakingReward = ((_lastRewardBlockTime - stakeDuration) / SECONDS_PER_DAY) * DAILY_REWARD;
        }
    }

    function _updateTotalStakingReward() internal {
        uint256 totalReward = rewardToken.balanceOf(address(this));
        uint32 currentBlockTimestamp = uint32(block.timestamp);
        if (totalReward == 0) {
            _lastRewardBlockTime = currentBlockTimestamp;
        }

        uint256 rewardToMint = ((currentBlockTimestamp - _lastRewardBlockTime) / SECONDS_PER_DAY) * DAILY_REWARD; 
        rewardToken.mint(address(this), rewardToMint * 10 ** 18);
        _totalStakingReward += rewardToMint;
        emit TotalStakingRewardUpdated();
    }

    modifier _isNftStaked(uint256 id) {
        // get existedStake by id
        Stake memory existedStake = stakes[id];

        // check if address is 0 - this indicate if stake exists
        require(existedStake.originalOwner != address(0), "stake not exists");

        // check original owner for the NFT against msg.sender
        require(msg.sender == existedStake.originalOwner, "withdrawer not original owner");

        _;
    }
}