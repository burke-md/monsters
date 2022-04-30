// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./BattleData.sol";

contract BattleGetters is BattleData {

  using Counters for Counters.Counter;

  // @notice The getNumBattleRecords funtion is a simple getter funtion for testing the auto incrementing value for battleId.

  // @returns uint256 battleId of most recent initiated battle.

  function getNumBattleRecords () public view returns(uint256) {
    return _battleId.current();
  }

  // @notice The getBattleCompletionState function is a simple getter function that returns if a battle has been completed or not.

  // @returns bool This value will be false until all calculations are complete and values are updated as nessisary. 

  function getBattleCompletionState (uint256 battleId) public view returns (bool) {
    return battleHistory[battleId].isComplete;
  }

  // @notice The getBattleMovesArr function is a simple getter function.

  // @returns array of strings [initiatorMove, opponentMove].

  function getBattleMovesArr (uint256 battleId) public view returns (string[] memory) {

    string[] memory moves = new string[](2);

    moves[0] = battleHistory[battleId].initiatorMove;
    moves[1] = battleHistory[battleId].opponentMove;

    return moves;
  }

  // @notice The getBattleResult function is a simple getter function.

  // @returns string(initator, opponent, draw).
  
  function getBattleResult (uint256 battleId) public view returns (string memory) {
    return battleHistory[battleId].result;
  }
}