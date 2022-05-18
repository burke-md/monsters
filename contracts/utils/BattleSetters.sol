// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BattleData.sol"

contract BattleSetters  is BattleData {
    
    /** @notice setMonsterContractAddress will be used once to establish a 'constant'
    *   which is used in the calling of a Monster contract function by the
    *   Battle contract.
    *
    */
    
    function setMonsterContractAddress(
        address _monsterContractAddress)
        public
        onlyOwner {
            
            monsterContractAddress = _monsterContractAddress;
}
