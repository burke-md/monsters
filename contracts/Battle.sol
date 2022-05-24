// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/BattleDefinitions.sol";
import "./utils/BattleData.sol";
import "./utils/BattleGetters.sol";
import "./utils/BattleValidators.sol";

interface IMonster {
    function updateElo(uint256 monsterId, uint8 points) external;
}

contract Battle is Ownable, 
    BattleDefinitions, 
    BattleData, 
    BattleGetters, 
    BattleValidators {

    using Counters for Counters.Counter;

    /** @notice initiateBattle function is the first step in the battle
    *   mechanics. It stores and emits some data. 
    *   There are no calculations made here.
    */

    function initiateBattle(
        uint256 initiatorMonsterId, 
        uint256 opponentMonsterId) 
        public {
        //Insure initiator owns monster
        //_validateMonsterOwner
        //require(true, 
                //"BATTLE: The initiator of a battle must own the initiating monster.")

        _battleId.increment();

        BattleInfo memory battleSet;
        battleSet = BattleInfo({ 
            id: _battleId.current(),
            initiator: initiatorMonsterId,
            opponent: opponentMonsterId,
            isComplete: false,
            initiatorMovesHash: NULL_BTS32,
            opponentMovesHash: NULL_BTS32,
            initiatorMovesArr: new uint8[](0),
            opponentMovesArr: new uint8[](0),
            result: 3
        });

        battleHistory[_battleId.current()] = battleSet;

        emit NewBattleRecord(
            _battleId.current(), 
            initiatorMonsterId, 
            opponentMonsterId);
    }

    /** @notice commitBattleMovesHash is a function that each competitor will
    *   call for themselves. This is the begining of the comit/reveal pattern.
    *
    *   STEP 1:
    *       The front end will hash(keccak256) an array of moves and a secret 
    *       pass phrase.
    *   STEP2:
    *       Calling this function(commitBattleMovesHash), the hash will be 
    *       stored on chain.
    *   STEP3:
    *       After the second player's hash is stored an event will be emitted.
    *       This state is also be available via a getter function
    *       (getMovesHashCommited will return a bool).
    *   STEP4:
    *       User will re-enter their moves array and pass phrase. These will be
    *       hashed on chain. If the two hashes match, the moved will be 
    *       considered valid. The outcome will then be calculated and ELO 
    *       points awarded. 
    *
    */

    function commitBattleMovesHash(
        uint256 battleId, 
        uint256 monsterId,
        bytes32 movesHash) 
        public {

            //_validateMonsterOwner
            require(true,
                    "BATTLE: Only monster owner can commit battle movesHash.");
            require(_validateBattleParticipant(battleId, monsterId), 
                    "BATTLE: This monster is not a participant in this battle.");
            require(_validateBattleHashRequired(battleId, monsterId), 
                    "BATTLE: Your moves hash has already been commited.");
        
            if (monsterId == battleHistory[battleId].initiator) {
                battleHistory[battleId].initiatorMovesHash = movesHash;
            }
            
            if (monsterId == battleHistory[battleId].opponent) {
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
        uint256 monsterId,
        uint8[] memory movesArr,
        string memory passPhrase)
        public {
            
            bytes32 storedMovesHash;

            if (battleHistory[battleId].initiator == monsterId) {
                storedMovesHash = battleHistory[battleId].initiatorMovesHash;
            } else {
                storedMovesHash = battleHistory[battleId].opponentMovesHash;
            }
            
            require(_validateBattleMovesFromHash(
                storedMovesHash,
                passPhrase,
                movesArr), "BATTLE: Invalid passphrase.");

            if (battleHistory[battleId].initiator == monsterId) {
                battleHistory[battleId].initiatorMovesArr = movesArr;
            } else if (battleHistory[battleId].opponent == monsterId) {
                battleHistory[battleId].opponentMovesArr = movesArr;
            }
            
            /** @dev Each battle is initiated with movesArray length 0.
            *   This check for length 3 will show that both sets of moves have 
            *   been revealed.
            */

            if (battleHistory[battleId].initiatorMovesArr.length == 3 &&
                battleHistory[battleId].opponentMovesArr.length == 3) {
                _evaluateBattleMoves(battleId);
            }
    }

    /** @notice The _evaluateBattleMoves function is the third step in the 
    *   battle mechanics. It discovers which party has won the single move 
    *   battle. It then calls another function to update the BattleInfo struct 
    *   and emit an event.
    */

    function _evaluateBattleMoves(uint256 battleId) internal {
        uint8 result = 3;
        
        uint8[] memory initiatorArr = battleHistory[battleId].initiatorMovesArr;
        uint8[] memory opponentArr =  battleHistory[battleId].opponentMovesArr;

        require(initiatorArr.length == opponentArr.length, 
        "BATTLE: Lists of moves are not of equal length.");
        
        for (uint8 i = 0; i < 2; i ++) {

            uint8 initiatorMove = initiatorArr[i];
            uint8 opponentMove = opponentArr[i];
            
            if (initiatorMove < opponentMove && 
                opponentMove != 0) result -= 1;
            if (initiatorMove > opponentMove) result += 1;
        }

            _updateBattleInfoResult(result, battleId);
    }

    /** @notice The _updateBattleInfoResult function is the fourth step in the 
    *   battle mechanics. It is called internally and will update the 
    *   BattleInfo strucut, then emit an event.
    */

    function _updateBattleInfoResult(
        uint8 result, 
        uint256 battleId) 
        internal {

        battleHistory[battleId].result = result;

        emit CompletedEvaluation(battleId, result);
        _evaluateMonsterElo(battleId, result);
    }


    /*   @notice The _updateMonsterElo function is fifth step in the battle 
    *   mechanics. It will update the onchain ELO data pertaining to each 
    *   monster. Somewhat akin to an xp value.
    *
    *   @param result should be within the range of 1-5 (inclusive). 
    *   Where 3 is neutral, a draw. 5 would assign two wins to the opponent, 
    *   while 1 would assign two wins to the initiator.
    *
    *   INITIATOR 2 wins <-- 1 win <-- draw --> 1 win --> 2 wins OPPONENT
    */

    function _evaluateMonsterElo(
        uint256 battleId,
        uint8 result) 
        internal {
        
        string memory outcome;
        uint8 eloIncrease;
        uint256 initiatorMonster = battleHistory[battleId].initiator;
        uint256 opponentMonster = battleHistory[battleId].opponent;

        if (result == 3) {
            outcome = "DRAW";
            eloIncrease = 0;
        }

        if (result > 3) {
            outcome = "OPPONENT"; 
            eloIncrease = (result - 3) *  ELO_POINTS_PER_WIN;
            _updateWinner(opponentMonster, eloIncrease);
        }

        if (result < 3) {
            outcome = "INITIATOR";
            eloIncrease = (3 - result) *  ELO_POINTS_PER_WIN;
            _updateWinner(initiatorMonster, eloIncrease);
        }

        emit EloUpdate(battleId, outcome, eloIncrease);
    }

    /** @notice _updateWinner will call a function within the Monster contract
    *   to update the monster's ELO score (on chain data point).
    */

    function _updateWinner(uint256 monsterId, uint8 eloIncrease) internal {
        IMonster(monsterContractAddress).updateElo(monsterId, eloIncrease);
    }

/** TODO
- Implement require in _initiateBattle (check for ownership)
- Prevent multiple battles
*/
}
