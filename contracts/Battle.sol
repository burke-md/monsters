// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/BattleDefinitions.sol";
import "./utils/BattleData.sol";
import "./utils/BattleGetters.sol";
import "./utils/BattleValidators.sol";

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
            initator: msg.sender,
            opponent: opponent,
            isComplete: false,
            initiatorMovesHash: null,
            opponentMovesHash: null,
            initiatorMovesArr: [],
            opponentMovesArr: [],
            result: ""
        });

        battleHistory[_battleId.current()] = battleSet;

        emit NewBattleRecord(_battleId.current(), 
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
        
        if (msg.sender === battleHistory[battleId].initiator) {
            battleHistory[battleId].initiatorMovesHash = movesHash;
        }
        
        if (msg.sender === battleHistory[battleId].opponent) {
            battleHistory[battleId].opponentMovesHash = movesHash;
        }
        
        if (battleHistory[battleId].opponentMovesHash != null &&
           battleHistory[battleId].initiatorMovesHash != null) {
            emit BattleHashesCommit(battleId);
        } 
    }

    /** @notice The _defineBattleMoves function is the second step in the 
    *   battle mechanics. It stores the two parties moves in the BattleInfo 
    *   struct.
    */
    function _defineBattleMoves(
        uint256 battleId, 
        uint8 initiatorMove, 
        uint8 opponentMove) 
        public onlyOwner {
    
        require(_validateMoveInput(initiatorMove) == true, 
                "Invalid initiator move definition.");
        require(_validateMoveInput(opponentMove) == true, 
                "Invalid opponent move definition.");
    

        battleHistory[battleId].initiatorMove = initiatorMove;
        battleHistory[battleId].opponentMove = opponentMove;
    }

    /** @notice The _evaluateBattleMoves function is the third step in the 
    *   battle mechanics. It discovers which party has won the single move 
    *   battle. It then calls another function to update the BattleInfo struct 
    *   and emit an event.
    */

    function _evaluateBattleMoves(uint256 battleId) public onlyOwner  {

        string memory result;
        uint8 initiatorMove = battleHistory[battleId].initiatorMove;
        uint8 opponentMove =  battleHistory[battleId].opponentMove;

        if (initiatorMove == opponentMove) result = "DRAW";
        if (initiatorMove < opponentMove && 
            opponentMove != 0) result = "INITIATOR";
        if (initiatorMove > opponentMove) result = "OPPONENT";

        _updateBattleInfoResult(result, battleId);
    }

    /** @notice The _updateBattleInfoResult function is the fourth step in the 
    *   battle mechanics. It is called internally and will update the 
    *   BattleInfo strucut, then emit an event.
    */
    function _updateBattleInfoResult(
        string memory result, 
        uint256 battleId) 
        internal {

        address initiator = battleHistory[battleId].initator;
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
    *   @param 'points' should be within the range of 1-5 (inclusive). 
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
            _updateMonsterElo(opponent, eloIncrease);
        }

        if (points < 3) {
            outcome = "INITIATOR";
            eloIncrease = (3 - points) *  ELO_POINTS_PER_WIN;
            _updateMonsterElo(initiator, eloIncrease);
        }

        emit EloUpdate(battleId, outcome, eloIncrease);
    }

    /** @notice
    *
    */
    function _updateWinner(address monster, uint8 eloIncrease) internal {
    //handle access to monsters contract
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
-adjust winner/looser ELO score
-prevent multiple battles
- Resolve "blind move" issue.
-refactor for modularity etc.
- Review function access modifiers
*/
}
