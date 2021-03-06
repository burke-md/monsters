// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BattleDefinitions {
    /** @notice The constant NULL has been created to cleanly define empty string value while testing state or initiating 
    *   bytes32/string fields.
     */
    bytes32 constant NULL_BTS32 = "";

     /** @notice The constant NULL_STR has been created to cleanly define empty string value while testing state or initiating 
    *    string fields.
     */
    string constant NULL_STR = "";

    /** @notice This struct is used to store data regaurding each individual 
    *   battle and will be updated as needed.
    */

    struct BattleInfo {
        uint256 id;
        uint256 initiator;
        uint256 opponent;
        bool isComplete;
        bytes32 initiatorMovesHash;
        bytes32 opponentMovesHash;
        uint8[] initiatorMovesArr;
        uint8[] opponentMovesArr;
        uint8 result;
  }

    /** @notice NewBattleRecord is the definition for the event to be emitted 
    *   as a battle is initiated.
    */
  
    event NewBattleRecord (
        uint256 indexed battleId,
        uint256 sender,
        uint256 opponent
    );

    /** @notice CompletedEvaluation is the definition for the event to be 
    *   emitted after battle moves are evaluated (as the BattleInfo struct 
    *   is updated).
    */
    event CompletedEvaluation (
        uint256 indexed battleId,
        uint8 indexed result
    );

    /** @notice EloUpdate is the definition for the event to be emitted after 
    *   a battle is complete and both monsters have been updated. 
    */
    event EloUpdate (
        uint256 indexed battleId,
        string winner,
        uint8 eloIncrease
    );

    /** @notice BattleHashedCommited will be emitted after both parties have 
    *   locked in their hash of moves array and pass code.
    */
    event BattleHashesCommited(uint256 indexed battleId);

    /** @notice All 'move' storage and evaluation will be based on the type 
    *   uint8.
    */

  enum MoveChoice { BITE, LEG, ARM }
}
