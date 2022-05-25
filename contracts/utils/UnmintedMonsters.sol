// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./MonsterData.sol";

contract UnmintedMonsters is MonsterData {

    constructor() {
        /** index #0 in array will contain unmintedMonster #1 etc.
        *   maxSupply is a constant defined in MonsterData.sol
        */
        for (uint256 i = 0; i < maxSupply; i++) {
        unmintedMonsters.push(i+1); 
        }
    }

    uint256[] internal unmintedMonsters;

    using Counters for Counters.Counter;


    function getIdUnminted(uint index) public view returns(uint){
        uint id = unmintedMonsters[index];
        return id;
    } 
/*
    function getMintedCount() public view returns(uint){
        return _tokenIdCounter.current();
    }
*/
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
/*
    function _tokenIdCounterIncrement () public {
        _tokenIdCounter.increment();
    }
   */
}
