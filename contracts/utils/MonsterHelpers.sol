// SPDX-License-Identifier: MIT
Pragma solidity ^0.8.4;


contract MonsterHelpers{

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
}