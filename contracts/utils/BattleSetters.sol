// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BattleData.sol";

contract BattleSetters  is Ownable, BattleData {
    
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
}
