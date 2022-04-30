// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BattleDefinitions {

  // @notice This struct is used to store data regaurding each individual battle and will be updated as needed.

  struct BattleInfo {
    uint256 id;
    address initator;
    address opponent;
    bool isComplete;
    string initiatorMove;
    string opponentMove;
  }

  // @notice This is the definition for the event to be emitted as a battle is initiated.
  event NewBattleRecord(
    address indexed sender,
    address indexed opponent,
    uint256 indexed battleId
  );

}