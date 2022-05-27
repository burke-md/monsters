<<<<<<< HEAD
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
 
contract MonsterData {  
    
    constructor() {
        /** index #0 in array will contain unmintedMonster #1 etc.
        *   maxSupply is a constant defined in MonsterData.sol
        */
        for (uint256 i = 0; i < maxSupply; i++) {
            unmintedMonsters.push(i+1); 
        }
    }

    using Counters for Counters.Counter;  

    /**
    * @notice _tokenIdCounter will be incremented on mint and referenced 
    * throughout.
    */
    
    Counters.Counter internal _tokenIdCounter;

    uint256[] internal unmintedMonsters;

    uint constant startingElo = 600;

    function getIdUnminted(uint index) public view returns(uint){
        uint id = unmintedMonsters[index];
        return id;
    } 

    function getLengthUnmintedMonsters() public view returns(uint){
        return unmintedMonsters.length;
    }

    function removeUnmintedId(uint index) internal{
        if (index >= unmintedMonsters.length) return;

        for (uint i = index; i < unmintedMonsters.length-1; i++){
            unmintedMonsters[i] = unmintedMonsters[i+1];
        }
        unmintedMonsters.pop();
    }
}
