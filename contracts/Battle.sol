// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Battle is Ownable {

  constructor(){}

  using Counters for Counters.Counter;
  Counters.Counter private _battleId;

  event NewBattleRecord(
    address indexed sender,
    address indexed opponent,
    uint256 indexed battleId
  );

  //Initiator add => opponent add => battleId
  mapping(address => mapping(address => uint256))
    public battleHistory;

  function initiateBattle(address opponent) public {
    _battleId.increment();

    battleHistory[msg.sender][opponent] = _battleId.current();

    emit NewBattleRecord(msg.sender, opponent, battleHistory[msg.sender][opponent]);
  }
}




/* TODO
X counter for battle
X create new battle, w/ 2x address and battle id
X emit event
-calculate winner
-update battle record
-adjust winner/looser ELO score
*/