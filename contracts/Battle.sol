// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./utils/BattleDefinitions.sol";
import "./utils/BattleData.sol";
import "./utils/BattleGetters.sol";

contract Battle is Ownable, BattleDefinitions, BattleData, BattleGetters {

  using Counters for Counters.Counter;

  // @notice The _isValidMoveInput function will insure that non-approved 'moves' are not input into the BattleInfo struct.

  function _validateMoveInput(uint8 move) internal pure returns (bool) {
    bool isValid = false;

    if(move >= 0) isValid = true;
    if(move <= 2) isValid = true;

    return isValid;
  }


  // @notice The initiateBattle function is the first step in the battle mechanics. It simply stores and emits some data. There are no calculations made here.

  function initiateBattle(address opponent) public {
    _battleId.increment();

    BattleInfo memory battleSet;
    battleSet = BattleInfo({
      id: _battleId.current(),
      initator: msg.sender,
      opponent: opponent,
      isComplete: false,
      initiatorMove: 3,
      opponentMove: 3,
      result: ""
    });

    battleHistory[_battleId.current()] = battleSet;

    emit NewBattleRecord(msg.sender, opponent, _battleId.current());
  }

  // @notice The _defineBattleMoves function is the second step in the battle mechanics. It stores the two parties moves in the BattleInfo struct.

  function _defineBattleMoves(uint256 battleId, uint8 initiatorMove, uint8 opponentMove) public onlyOwner {
    
    require(_validateMoveInput(initiatorMove) == true, "Invalid initiator move definition.");
    require(_validateMoveInput(opponentMove) == true, "Invalid opponent move definition.");
    

    battleHistory[battleId].initiatorMove = initiatorMove;
    battleHistory[battleId].opponentMove = opponentMove;
  }

  // @notice The _evaluateBattleMoves function is the third step in the battle mechanics. It discovers which party has won the single move battle and updates the BattleInfo struct.

  function _evaluateBattleMoves(uint256 battleId) public onlyOwner  {

    string memory result;
    uint8 initiatorMove = battleHistory[battleId].initiatorMove;
    uint8 opponentMove =  battleHistory[battleId].opponentMove;

    if (initiatorMove == opponentMove) result = "DRAW";
    if (initiatorMove < opponentMove && 
      opponentMove != 0) result = "INITIATOR";
    if (initiatorMove > opponentMove) result = "OPPONENT";

    battleHistory[battleId].result = result;
  }

  function _updateBattleInfoResult(string memory result) internal {

  }


  /* TODO
X counter for battle
X create new battle, w/ 2x address and battle id
X emit event
X store moved in battle struct?
X function for inputting "moves"
X require moved to be of acceptable type
X calculate winner
X update battle record
-adjust winner/looser ELO score
-refactor for modularity etc.
- Resolve "blind move" issue.
- Review function access modifiers
*/
}