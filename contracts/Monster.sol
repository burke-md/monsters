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


interface Monster {

  function _updateElo(address monster, uint8 points) external onlyBatle;
}


contract Monster is ERC721, 
    ERC721Pausable, 
    ERC721Burnable, 
    ERC721URIStorage, 
    Ownable 
    AccessControl {

//->using statment for Counters
//->create private counter na
 

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
    // Counters.Counter is a pre-defined struct variable format, we're defining one Counters.counter called _tokenIdCounter

  uint mintPrice = 0.05 ether;
  uint maxSupply = 1000;
  uint randNumModulus = 10 ** 12;
  address battleContract address;

  constructor () ERC721("Monster", "MON") {} 

  mapping (uint => uint) IdToElo;

  event NewMonster(uint monsterId, uint Elo);

  modifier onlyBattle {
    _;
  }

  /**
  *
  * @dev SetBattleContract will be used to insert the contract address, which 
  * will only be known after deployment.
  *
  */
  function setBattleContractAdress(address contractAddress)  public onlyOwner {
  
  }

  function pause() public onlyOwner {
    _pause();
  }

//->create unpause func w/ onlyOwner modifyer (see above)
  function unpause() public onlyOwner {
    _unpause();
  }

   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused override (ERC721, ERC721Pausable){
    super._beforeTokenTransfer(from, to, tokenId);
  }


  function _generateRandNum() internal returns(uint){
  
    // call vrf
    //vrfFeeEth = SafeMathChainlink.mul(currentPrice());

    //uint randNum = vrf();
    // need to find what the vrf function syntax is
    //return randNum % randNumModulus;
  }




  function _GenerateNewTokenId() internal returns(uint) {
  
    uint randNum = _generateRandNum();
    uint tokenId = (randNum / randNumModulus ) * (maxSupply); // range: 0 to (maxSupply - 1)

    for (uint i = 0; i < maxSupply; i++) {
      if (IdMinted[tokenId] = true) {
        tokenId = tokenId++;

        if (tokenId >= maxSupply) {
          tokenId = tokenId - maxSupply;
        }
      }
    }
    return tokenId;
  }



  function mintMonster() public payable whenNotPaused {
    
    require((_tokenIdCounter.current() + 1) <= maxSupply,
            "Monsters: Mint would exceed maxSupply");
    //require(_mintPrice + _vrfFeeEth <= msg.value, "Ether value sent is not correct");

    uint startingElo = 600;
    uint newTokenId = _GenerateNewTokenId();

    //_safeMint(msg.sender, tokenId);

    _tokenIdCounter.increment();
    IdToAddress[newTokenId] = msg.sender;
    IdToElo[newTokenId] = startingElo;
    IdMinted[newTokenId] = true;

    emit NewMonster(newTokenId, IdToElo[newTokenId]);
  }



  function _mintMonster(address _ownerAddress, uint _tokenId) internal onlyOwner {
    
    _ownerAddress = msg.sender;
    _tokenId = _vrfToTokenId(_vrfNum);

    _safeMint(_ownerAddress, _tokenId, _data);
    _tokenIdCounter.increment();
  }

/*
->Uncomment the following function 
after pause/unpause implemented

  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
  internal
  whenNotPaused
  override
  {
    super._beforeTokenTransfer(from, to, toekId)
  }
*/

//@Notice The following functions are overrides required to resolve conflict issues.

//->Uncomment after libs are imported

/*
  function _burn(uint256 tokenId) internal Override(ERC721, ERC721Storage) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokeId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return super.tokenURI(tokenID)
function _burn(uint256 tokenId) 
  internal 
  override (ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }


/*
set URI
*/

  function tokenURI(uint256 tokenId) 
    public 
    view 
    override(ERC721, ERC721URIStorage)
    returns (string memory){
       return super.tokenURI(tokenId);
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

  function _updateElo(address monster, uint8 points) external onlyBattle {

  }
*/
}





