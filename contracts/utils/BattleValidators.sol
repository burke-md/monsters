// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract BattleValidators {
   // @notice The _isValidMoveInput function will insure that non-approved 'moves' are not input into the BattleInfo struct.

  function _validateMoveInput(uint8 move) internal pure returns (bool) {
    bool isValid = false;

    if(move >= 0) isValid = true;
    if(move <= 2) isValid = true;

    return isValid;
  }
}