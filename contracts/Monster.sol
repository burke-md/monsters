// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//See Figjam for list
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./utils/MonsterHelpers.sol";
import "./utils/MonsterData.sol";
import "./utils/UnmintedMonsters.sol";

contract Monster is ERC721, 
    ERC721Burnable, 
    ERC721URIStorage, 
    AccessControl,
    MonsterHelpers,
    UnmintedMonsters {

  uint mintPrice = 0.05 ether;
  uint randNumModulus = 10 ** 12;
  address battleContractAddress;


  mapping (uint => uint) IdToElo;

  event NewMonster(uint monsterId, uint Elo);
        
    /**
    *   @notice onlyBattle modifier will ensure only the battle contract calls 
    *   the update ELO function.
    */
    modifier onlyBattle {
        require(msg.sender == battleContractAddress,
            "MONSTER: Confirm battle address has been set by owner and that this function is only being called from the Battle contract.");
        _;
    }

  constructor () ERC721("Monster", "MON") {}


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


  function mintMonster() public payable whenNotPaused {
    
    require((_tokenIdCounter.current() + 1) <= MonsterData.maxSupply,
            "Monsters: Mint would exceed maxSupply");
    //require(_mintPrice + _vrfFeeEth <= msg.value, "Ether value sent is not correct");

    uint startingElo = 600;
    uint newTokenId = _GenerateNewTokenId();

    _safeMint(msg.sender, newTokenId);

    _tokenIdCounter.increment();
    IdToElo[newTokenId] = startingElo;
    removeUnmintedId(newTokenId - 1 - _tokenIdCounter);

    emit NewMonster(newTokenId, IdToElo[newTokenId]);
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
  internal
  whenNotPaused
  override
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  /*
  set URI
  */

  function _burn(uint256 tokenId) 
    internal 
    override 
    (ERC721, ERC721URIStorage) 
    {
      super._burn(tokenId);
    }

    /**
    * @notice The _updateElo  function will be made available via the interface. 
    * It will be called after a battle is resolved to add points to the winner.
    * At this time ELO points will ONLY increment. There is not decrement 
    * functionality.
    *
    * @ require updateElo can only be called by the Battle contract. 
    *
    */

    function updateElo(uint256 monsterId, uint8 points) external onlyBattle {
        uint currenElo = IdToElo[monsterId];
        IdToElo[monsterId] = currenElo + points;
    }

    /** @notice checkOwnership is a funtion to be called by the Battle contract
    *   to insure only the owners of monsters and battling with them.
    */

    function checkOwnership(
        address _owner, 
        uint256 monsterId) 
        external 
        onlyBattle
        returns (bool isValid) {
            
            if (ownerOf(monsterId) == _owner) return true;

            return false;
    }
}
