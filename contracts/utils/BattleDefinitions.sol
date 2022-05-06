// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BattleDefinitions {

  // @notice This struct is used to store data regaurding each individual battle and will be updated as needed.

  struct BattleInfo {
    uint256 id;
    address initator;
    address opponent;
    bool isComplete;
    uint8 initiatorMove;
    uint8 opponentMove;
    string result;
  }

  // @notice NewBattleRecord is the definition for the event to be emitted as a battle is initiated.
  
  event NewBattleRecord (
    uint256 indexed battleId,
    address sender,
    address opponent
  );

  // @notice CompletedEvaluation is the definition for the event to be emitted after battle moves are evaluated (as the BattleInfo struct is updated).

  event CompletedEvaluation (
    uint256 indexed battleId,
    string indexed result,
    address initiator,
    address opponent
  );

  // @notice EloUpdate is the definition for the event to be emitted after a battle is complete and both monsters have been updated. 
  event EloUpdate ();

  // @notice All 'move' storage and evaluation will be based on the type uint8

  enum MoveChoice { BITE, LEG, ARM }
}