// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/BattleDefinitions.sol";
import "./utils/BattleData.sol";
import "./utils/BattleGetters.sol";
import "./utils/BattleValidators.sol";

import "./Monster.sol";

contract Battle is Ownable, 
    BattleDefinitions, 
    BattleData, 
    BattleGetters, 
    BattleValidators {

    using Counters for Counters.Counter;

    /** @notice The initiateBattle function is the first step in the battle
    *   mechanics. It simply stores and emits some data. 
    *   There are no calculations made here.
    */
    function initiateBattle(address opponent) public {
        _battleId.increment();

        BattleInfo memory battleSet;
        battleSet = BattleInfo({ 
            id: _battleId.current(),
            initiator: msg.sender,
            opponent: opponent,
            isComplete: false,
            initiatorMovesHash: NULL_BTS32,
            opponentMovesHash: NULL_BTS32,
            initiatorMovesArr: new uint8[](0),
            opponentMovesArr: new uint8[](0),
            result: NULL_STR
        });

        battleHistory[_battleId.current()] = battleSet;

        emit NewBattleRecord(
            _battleId.current(), 
            msg.sender, 
            opponent);
    }

    /** @notice commitBattleMovesHash is a function that each competitor will
    *   call for themselves. This is the begining of the comit/reveal pattern.
    *
    *   STEP 1:
    *       The front end will hash an array of moves and a secret pass phrase.
    *   STEP2:
    *       Calling this function, the hash will be stored on chain.
    *   STEP3:
    *       After the second hash is stored an event will be emitted.
    *   STEP4:
    *       User will re-enter their moves array and pass phrase. These will be
    *       hashed on chain. If the two hashes match, the moved will be valid.
    *       The outcome will be calculated and ELO points awarded. 
    *
    */
    function commitBattleMovesHash(uint256 battleId, bytes32 movesHash) public {
        require(_validateBattleParticipant(battleId, msg.sender), 
                "BATTLE: You are not a participant in this battle.");
        require(_validateBattleHashRequired(battleId, msg.sender), 
                "BATTLE: Your moves hash has already been commited.");
        
        if (msg.sender == battleHistory[battleId].initiator) {
            battleHistory[battleId].initiatorMovesHash = movesHash;
        }
        
        if (msg.sender == battleHistory[battleId].opponent) {
            battleHistory[battleId].opponentMovesHash = movesHash;
        }
        
        if (battleHistory[battleId].opponentMovesHash != NULL_BTS32 &&
           battleHistory[battleId].initiatorMovesHash != NULL_BTS32) {
            emit BattleHashesCommited(battleId);(battleId);
        } 
    }

    /** @notice The revealBattleMoves function is the second step in the 
    *   battle mechanics. It accepts an array of moves and a pass phrase,
    *   validates the information and stores the confirmed moves array.
    *   Each participant will have to call this function individually.
    *
    *   @param passPhrase is a string value. Used both client side in the 
    *   creation of movesHash and in the revealBattleMoves function in this 
    *   contract. 
    *
    *   @param movesArr is an integer array of moves to be evaluated against
    *   the other participants moves.
    */
    function revealBattleMoves(
        uint256 battleId, 
        uint8[] memory movesArr,
        string memory passPhrase,
        bool isInitiator) 
        public {

        if (isInitiator) {
            require(msg.sender == battleHistory[battleId].initiator,
                "BATTLE: This function is only accessible to those in this battle.");
        } else if (!isInitiator) {
            require(msg.sender == battleHistory[battleId].opponent,
                "BATTLE: This function is only accessible to those in this battle.");
        }

        bytes32 storedMovesHash = isInitiator ? 
            battleHistory[battleId].initiatorMovesHash :
            battleHistory[battleId].opponentMovesHash;

        if(_validateBattleMovesFromHash(
            storedMovesHash, passPhrase, movesArr)) {
                
                isInitiator ?
                    battleHistory[battleId].initiatorMovesArr = movesArr :
                    battleHistory[battleId].opponentMovesArr = movesArr;
        }
    }

    /** @notice The _evaluateBattleMoves function is the third step in the 
    *   battle mechanics. It discovers which party has won the single move 
    *   battle. It then calls another function to update the BattleInfo struct 
    *   and emit an event.
    */

    function _evaluateBattleMoves(uint256 battleId) public onlyOwner  {
/* THIS LOGIC NEEDS TO BE REWORKED  
        string memory result;
        uint8 initiatorMove = battleHistory[battleId].initiatorMove;
        uint8 opponentMove =  battleHistory[battleId].opponentMove;

        if (initiatorMove == opponentMove) result = "DRAW";
        if (initiatorMove < opponentMove && 
            opponentMove != 0) result = "INITIATOR";
        if (initiatorMove > opponentMove) result = "OPPONENT";

        _updateBattleInfoResult(result, battleId);
        */
    }

    /** @notice The _updateBattleInfoResult function is the fourth step in the 
    *   battle mechanics. It is called internally and will update the 
    *   BattleInfo strucut, then emit an event.
    */
    function _updateBattleInfoResult(
        string memory result, 
        uint256 battleId) 
        internal {

        address initiator = battleHistory[battleId].initiator;
        address opponent = battleHistory[battleId].opponent;

        battleHistory[battleId].result = result;

        emit CompletedEvaluation(battleId, result, initiator, opponent);
    }


    /** @dev Consider reordering these functions.
    *
    *   @notice The _updateMonsterElo function is fifth step in the battle 
    *   mechanics. It will update the onchain ELO data pertaining to each 
    *   monster. Somewhat akin to an xp value.
    *
    *   @param points should be within the range of 1-5 (inclusive). 
    *   Where 3 is neutral, a draw. 5 would assign two wins to the opponent, 
    *   while 1 would assign two wins to the initiator.
    *
    *   INITIATOR 2 wins <-- 1 win <-- draw --> 1 win --> 2 wins OPPONENT
    */

    function _evaluateMonsterElo(
        address initiator, 
        address opponent, 
        uint8 points, 
        uint256 battleId) 
        internal {
        
        require(_validateEloPoints(points), 
                "Invalid data. Cannot update ELO values.");

        string memory outcome;
        uint8 eloIncrease;

        if (points == 3) {
            outcome = "DRAW";
            eloIncrease = 0;
        }

        if (points > 3) {
            outcome = "OPPONENT"; 
            eloIncrease = (points - 3) *  ELO_POINTS_PER_WIN;
            _updateWinner(opponent, eloIncrease);
        }

        if (points < 3) {
            outcome = "INITIATOR";
            eloIncrease = (3 - points) *  ELO_POINTS_PER_WIN;
            _updateWinner(initiator, eloIncrease);
        }

        emit EloUpdate(battleId, outcome, eloIncrease);
    }

    /** @notice _updateWinner will call a function within the Monster contract
    *   to update the monster's ELO score (on chain data point).
    */
    function _updateWinner(uint256 monsterId, uint8 eloIncrease) internal {
        MonsterInterface monster = MonsterInterface(monsterId, eloIncrease);
        monster();
    }

  /** TODO
X counter for battle
X create new battle, w/ 2x address and battle id
X emit event
X store moved in battle struct?
X function for inputting "moves"
X require moved to be of acceptable type
X calculate winner
X update battle record
X adjust winner/looser ELO score
-prevent multiple battles
X  Resolve "blind move" issue.
-refactor for modularity etc.
- Review function access modifiers
*/
}
