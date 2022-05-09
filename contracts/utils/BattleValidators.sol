// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BattleData.sol"; 

contract BattleValidators is BattleData {
    /** @notice The _isValidMoveInput function will insure that non-approved 
    *   'moves' are not input into the BattleInfo struct.
    */

    function _validateMoveInput(uint8 move) internal pure returns (bool) {
        bool isValid = false;

        if(move >= 0 && move <= 2) isValid = true;

        return isValid;
    }

    /** @notice The _validateEloPoints function will insure that only points 
    *   within the expected range are passed into _updateMonsterElo function.
    */
    function _validateEloPoints(uint8 points) internal pure returns (bool){
        bool isValid = false;

        if (points >= 1 && points <= 5) isValid = true;

        return isValid;
    }

    /** @notice The _validateBattleParticipant function will insure only
    *   participants can enter moves into the battle info struct.
    */
    function _validateBattleParticipant(uint256 battleId, address participant)
        internal 
        pure
        returns (bool) {
        
            if (battleHistory[battleId].initiator == participant || 
                battleHistory[battleId].opponent == participant) {
                return true;
            }

            return false;
    }

    /** @notice _validateBattleHashRequired is a quick check to ensure this 
    *   data is only entered once and is never overwritten.
    */
    function _validateBattleHashRequired(uint256 battleId, address participant)
        internal
        pure
        returns (bool) {
            
            if (battleHistory[battleId].initiator == participant &&
                battleHistory[battleId].initiatorMovesHash == null) {
                return true;
            }

             
            if (battleHistory[battleId].opponent == participant &&
                battleHistory[battleId].opponentMovesHash == null) {
                return true;
            }

            return false;
        }
}
