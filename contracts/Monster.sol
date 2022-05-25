// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//See Figjam for list
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./utils/MonsterHelpers.sol";
import "./utils/UnmintedMonsters.sol";


interface Monster {

  function _updateElo(address monster, uint8 points) external onlyBattle;
}

contract Monster is ERC721, 
    ERC721Pausable, 
    ERC721Burnable, 
    ERC721URIStorage, 
    Ownable, 
    AccessControl,
    MonsterHelpers,
    UnmintedMonsters {
 

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;

  uint mintPrice = 0.05 ether;
  uint maxSupply = 3;
  uint randNumModulus = 10 ** 12;
  address battleContract;

  uint256[] internal unmintedMonsters;

  mapping (uint => uint) IdToElo;

  event NewMonster(uint monsterId, uint Elo);

  constructor () ERC721("Monster", "MON") {

    for (uint256 i = 0; i < maxSupply; i++) {
      unmintedMonsters.push(i+1); // index #0 in array will contain unmintedMonster #1 etc.
    }
  } 


  /**
  *
  * @dev SetBattleContract will be used to insert the contract address, which 
  * will only be known after deployment.
  *
  */

  function _generateRandNum() internal returns(uint){
  
    // call vrf
    //vrfFeeEth = SafeMathChainlink.mul(currentPrice());

    //uint randNum = vrf();
    // need to find what the vrf function syntax is
    //return randNum % randNumModulus;
  }

  function _GenerateNewTokenId() internal returns(uint) {
  
    uint randNum = _generateRandNum();

    uint tokenIndex = (randNum / randNumModulus) * (unmintedMonsters.length); // range: 0 to (unmintedMonsters.length - 1)
    uint tokenId = unmintedMonsters[tokenIndex];

    return tokenId;
  }

  function _baseURI() internal pure override returns (string memory) {
    return "ipfs/QmZLnaUGeUDm2HJmNeMhPh42GCexHbrQZGdjsTtqjUCGza/";
  }

  function _getLevel(uint256 tokenId) public view returns (string memory level) {

    uint elo = IdToElo[tokenId];
    string level;

        if (elo < 1000) level = "a";
        else if (elo < 1500) level = "b";
        else level = "c";

    return level;
  }

  function _setFullTokenURI(uint tokenId) internal {

    string memory folderURI = super.tokenURI(tokenId);
    string memory level = _getLevel(tokenId);

    string memory fullTokenURI = string(abi.encodePacked(folderURI, "/", level, ".png")); 

    _setTokenURI(tokenId, fullTokenURI);

  }

  function mintMonster() public payable whenNotPaused {
    
    require((_tokenIdCounter.current() + 1) <= maxSupply,
            "Monsters: Mint would exceed maxSupply");
    //require(_mintPrice + _vrfFeeEth <= msg.value, "Ether value sent is not correct");

    uint startingElo = 600;
    uint newTokenId = _GenerateNewTokenId();

    _safeMint(msg.sender, newTokenId);

    _tokenIdCounter.increment();
    IdToElo[newTokenId] = startingElo;
    removeUnmintedId(newTokenId - 1 - _tokenIdCounter);

    _setFullTokenURI(newTokenId);

    emit NewMonster(newTokenId, IdToElo[newTokenId]);
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    override
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }


  function _burn(uint256 tokenId) 
    internal 
    override 
    (ERC721, ERC721URIStorage) 
  {
      super._burn(tokenId);
  }

  /**
  *
  * @notice The _updateElo  function will be made available via the interface. 
  * It will be called after a battle is resolved to add points to the winner.
  * At this time ELO points will ONLY increment. There is not decrement 
  * functionalit 
  *
  * @requires _updateElo can only be called by the Battle contract. 
  *
  */

  function updateElo(address winnerMonster, uint8 prebattleELO) external onlyBattle {
    

    

  }

}





