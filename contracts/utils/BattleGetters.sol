// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

import "./BattleData.sol";
import "./BattleDefinitions.sol";

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

    /** @notice The getBattleResult function is a simple getter function.
    *
    *   @return resultString string(initiator, opponent, draw).
    */
    function getBattleResult 
        (uint256 battleId) 
        public 
        view 
        returns (string memory resultString) {
            uint8 val = battleHistory[battleId].result;

            if (val < 3) return "INITIATOR";

            if (val == 3) return "DRAW";

            if (val > 3) return "OPPONENT";
    }

    /** @notice getMovesHashCommited returns a boolean value. It will confirm
    *   if BOTH participants have commited their moves hash.
    */
    function getMovesHashCommited (uint battleId) public view returns (bool) {

        return (battleHistory[battleId].initiatorMovesHash != NULL_BTS32 &&
                battleHistory[battleId].opponentMovesHash != NULL_BTS32);
    }
}
