// SPDX-License-Identifier: MIT
Pragma solidity ^0.8.4;


contract UnmintedMonsters{

function getIdUnminted(uint index) public view returns(uint){

        uint id = unmintedMonsters[index];
        return id;
    } 

function getMintedCount() public view returns(uint){
        return _tokenIdCounter;
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