// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Battle {

  constructor(){}

  event NewBattleRecord(
    address indexed sender,
    address indexed opponent,
    uint256 indexed battleId
  );

  //Initiator add => opponent add => battleId
  mapping(address => mapping(address => uint256))
    public battleHistory;

  function initiateBattle(address opponent) public {

    //Update =+1 => counter. This should be an incremented ID not frequently updated val.
    battleHistory[msg.sender][opponent] += 1;

    emit NewBattleRecord(msg.sender, opponent, battleHistory[msg.sender][opponent]);
  }
}




/* TODO
-counter for battle
-create new battle, w/ 2x address and battle id
-emit event
-calculate winner
-update battle record
-adjust winner/looser ELO score
*/