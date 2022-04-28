// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Battle {
  constructor (){}

  //Initiator add => opponent add => battleId
  mapping(address => mapping(address => uint256))
    public battleHistory;

  function initiateBattle(address opponent) public {
    //Update =+1 => counter. This should be an incremented ID not frequently updated val.
    battleHistory[msg.sender][opponent] += 1;
  }
}