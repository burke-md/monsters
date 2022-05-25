// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

contract MonsterData {
   
    /**
    * @notice _tokenIdCounter will be incremented on mint and referenced 
    * throughout.
    */
    
    using Counters for Counters.Counter;    
    Counters.Counter internal _tokenIdCounter;

    /** 
    * @notice maxSupply is a constant value for total possible number of 
    * monster NFTs.
    */
   
    uint maxSupply = 10;
}
