// SPDX-License-Identifier: MIT
Pragma solidity ^0.8.4;


contract BattleValidators{

function setBattleContractAdress(address contractAddress)  public onlyOwner {
  
  }

function changeBattleContractAddress(address memory _newAddress) public view onlyOwner{
    address _battleContractAddress = _newAddress;
  }

function battleContractAddress() public view returns(address){

    // Mike - on deploy we will need to create a variable that saves the created battle address. See ownable.sol

    return _battleContractAddress;
  }

function isBattle(address memory _battleAddress) public view returns(bool){
    
    return _battleAddress == _battleContractAddress;

    // verifies that the current battle's address matches up with the correct battle address
  }

modifier onlyBattle {
    require(isBattle());
    _;
  }

}