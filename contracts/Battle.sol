// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Battle is Ownable {

  using Counters for Counters.Counter;
  Counters.Counter private _battleId;

  struct BattleInfo {
    uint256 id;
    bool isComplete;
    string initiatorMove;
    string opponentMove;
  }

  event NewBattleRecord(
    address indexed sender,
    address indexed opponent,
    uint256 indexed battleId
  );

  // @dev Initiator add => opponent add => battleId 

  // @dev the battle Id will likely be replaced by a more complex struct in the future.

  mapping(address => mapping(address => BattleInfo))
    public battleHistory;

  // @notice The initiateBattle function is the first step in the battle mechanics. It simply stores and emits some data. There are no calculations made here.

  function initiateBattle(address opponent) public {
    _battleId.increment();

    BattleInfo memory battleSet;
    battleSet = BattleInfo({
      id: _battleId.current(),
      isComplete: false,
      initiatorMove: "",
      opponentMove: ""
    });

    battleHistory[msg.sender][opponent] = battleSet;

    emit NewBattleRecord(msg.sender, opponent, _battleId.current());
  }

  // @notice The getNumBattleRecords funtion is simply a getter funtion for testing the auto incrementing value for battleId.

  // @returns uint256 battleId of most recent initiated battle.
  function getNumBattleRecords () public view returns(uint256) {
    return _battleId.current();
  }

  function getBattleCompletionState (address initiator, address opponent) public view returns (bool) {
    return battleHistory[initiator][opponent].isComplete;
  }
}




/* TODO
X counter for battle
X create new battle, w/ 2x address and battle id
X emit event
- store moved in battle struct?
-calculate winner
-update battle record
-adjust winner/looser ELO score
*/