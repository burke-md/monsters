// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./BattleDefinitions.sol";

contract BattleData is BattleDefinitions{

  using Counters for Counters.Counter;
  Counters.Counter internal _battleId;

  // @dev battleId => BattleInfo <see struct def>

  mapping(uint256 => BattleInfo)
  public battleHistory;
}
