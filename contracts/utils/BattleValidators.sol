// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BattleValidators {
   // @notice The _isValidMoveInput function will insure that non-approved 'moves' are not input into the BattleInfo struct.

  function _validateMoveInput(uint8 move) internal pure returns (bool) {
    bool isValid = false;

    if(move >= 0 && move <= 2) isValid = true;

    return isValid;
  }

  // @notice The _validateEloPoints function will insure that only points within the expected range are passed into _updateMonsterElo function.
  function _validateEloPoints(uint8 points) internal pure returns (bool){
    bool isValid = false;

      if (points >= 1 && points <= 5) isValid = true;

    return isValid;
  }
}