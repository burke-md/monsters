// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

contract MonsterData {
    using Counters for Counters.Counter;    
    Counters.Counter internal _tokenIdCounter;
}
