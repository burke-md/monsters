// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


interface MonsterInterface {
    function _updateElo(address monster, uint8 points) external;
}


contract Monster is ERC721, 
    ERC721Pausable, 
    ERC721Burnable, 
    ERC721URIStorage, 
    Ownable {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;

  uint mintPrice = 0.05 ether;
  uint maxSupply = 1000;
  uint randNumModulus = 10 ** 12;
  address battleContractAddress;

  constructor () ERC721("Monster", "MON") {} 

  mapping (uint => uint) IdToElo;

  event NewMonster(uint monsterId, uint Elo);

    modifier onlyBattle {
        require(msg.sender == battleContractAddress,
                "MONSTER: Confirm battle address has been set by owner and that this function is only being called from the Battle contract.");
        _;
    }

    /**
    * @dev SetBattleContract will be used to update the contract address, 
    * which will only be known after deployment.
    *
    */
    function setBattleContractAdress(
        address contractAddress)  
        public onlyOwner {

        battleContractAddress = contractAddress;
    }

  function pause() public onlyOwner {
    _pause();
  }

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
		/* IdMinted undeclared
      if (IdMinted[tokenId] = true) {
        tokenId = tokenId++;

        if (tokenId >= maxSupply) {
          tokenId = tokenId - maxSupply;
        }
      }
	  */
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
	/* IdT0oAddrress undeclared
    IdToAddress[newTokenId] = msg.sender;
	*/
    IdToElo[newTokenId] = startingElo;
	/* IdMinsted undeclared
    IdMinted[newTokenId] = true;
	*/
    emit NewMonster(newTokenId, IdToElo[newTokenId]);
  }




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
  * @notice The _updateElo  function will be made available via the interface. 
  * It will be called after a battle is resolved to add points to the winner.
  * At this time ELO points will ONLY increment. There is not decrement 
  * functionality.
  *
  * @ require _updateElo can only be called by the Battle contract. 
  *
  */

  function _updateElo(address monster, uint8 points) external onlyBattle {

  }

}





