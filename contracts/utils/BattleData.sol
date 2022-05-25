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

  // @notice ELO_POINTS_PER_WIN is used in the _evaluateMonsterElo
  // function to determine appropriate increase. This value should be 
  // updated here if required. 

  uint8 constant ELO_POINTS_PER_WIN = 100;

    /** monsterContractAddress will be used in main Battle contract as constant
    *   while calling the updateElo function (which exists in the monster 
    *   contract). HOWEVER it must first be set after deployment. See
    *   battleSetters.sol
    */
    address monsterContractAddress;
}
