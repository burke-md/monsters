// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Battle is Ownable {

  using Counters for Counters.Counter;
  Counters.Counter private _battleId;

  struct BattleInfo {
    uint256 id;
    address initator;
    address opponent;
    bool isComplete;
    string initiatorMove;
    string opponentMove;
  }

  event NewBattleRecord(
    address indexed sender,
    address indexed opponent,
    uint256 indexed battleId
  );

  // @notice The _isValidMoveInput function will insure that non-approved 'moves' are not input into the BattleInfo struct.

  function _validateMoveInput(string memory move) internal pure returns (bool) {

    bool isValid = false;
    bytes32 moveToByes = keccak256(bytes(move));

    if(moveToByes == keccak256(bytes("ARM"))) isValid = true;
    if(moveToByes == keccak256(bytes("LEG"))) isValid = true;
    if(moveToByes == keccak256(bytes("BITE"))) isValid = true;

    return isValid;
  }

  // @dev battleId => BattleInfo <see struct def>

  mapping(uint256 => BattleInfo)
    public battleHistory;

  // @notice The initiateBattle function is the first step in the battle mechanics. It simply stores and emits some data. There are no calculations made here.

  function initiateBattle(address opponent) public {
    _battleId.increment();

    BattleInfo memory battleSet;
    battleSet = BattleInfo({
      id: _battleId.current(),
      initator: msg.sender,
      opponent: opponent,
      isComplete: false,
      initiatorMove: "",
      opponentMove: ""
    });

    battleHistory[_battleId.current()] = battleSet;

    emit NewBattleRecord(msg.sender, opponent, _battleId.current());
  }

  // @notice The _defineBattleMoves function is the second step in the battle mechanics. It stores the two parties moves in the BattleInfo struct.

  function _defineBattleMoves(uint256 battleId, string  memory initiatorMove, string memory opponentMove) public onlyOwner {
    require(_validateMoveInput(initiatorMove) == true, "Invalid initiator move definition.");
    require(_validateMoveInput(opponentMove) == true, "Invalid opponent move definition.");

    battleHistory[battleId].initiatorMove = initiatorMove;
    battleHistory[battleId].opponentMove = opponentMove;
  }

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
}




/* TODO
X counter for battle
X create new battle, w/ 2x address and battle id
X emit event
X store moved in battle struct?
-function for inputting "moves"
--require moved to be of acceptable type
-calculate winner
-update battle record
-adjust winner/looser ELO score
-refactor for modularity etc.
- Resolve "blind move" issue.
*/