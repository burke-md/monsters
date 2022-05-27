// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

contract MonsterData {
    
    /** @notice This counter will be used to keep track of and increment as 
    *   monsters are minted.
    */

    using Counters for Counters.Counter; 
    Counters.Counter internal _tokenIdCounter; 

    /** @notice maxSupply is a constant value used throughout this project. It
    *   is the total number of Monster NFTs that can be created.
    */

   uint8 constant maxSupply = 10;
}  

