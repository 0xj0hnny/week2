// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step} from  "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable2Step {
  constructor() ERC20("RewardToken", "RewardToken") Ownable(msg.sender) {
    acceptOwnership();
  }

  function mint(address _receiver, uint256 _amount) external {
    _mint(_receiver, _amount);
  }
}