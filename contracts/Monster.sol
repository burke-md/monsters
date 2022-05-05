// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
<<<<<<< HEAD
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//->Inherit imported libs
contract Monster is ERC721, Pausable, Ownable {

  constructor() ERC721("Monster", "MON") {}
=======
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
>>>>>>> db1414ba4578f18db58f8ef9183b54ea6ca40279

contract Monster is ERC721,ERC721Pausable,ERC721Burnable,ERC721URIStorage,Ownable,Counters {

<<<<<<< HEAD
//->Create mapping of addresses and tokenId


  function pause() public onlyOwner {
    _pause();
  }

=======
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;

  uint mintPrice = 0.05 ether;
  uint maxSupply = 1000;
  uint randNumModulus = 10 ** 12;

  constructor () public ERC721("Monster", "MON") {} 

  mapping (uint => address) IdToAddress;
  mapping (uint => uint) IdToElo;
  mapping (uint => bool) IdMinted; // default: false

  event NewMonster(uint monsterId, uint Elo);

  function pause() public onlyOwner {
    _pause();
  }
>>>>>>> db1414ba4578f18db58f8ef9183b54ea6ca40279

  function unpause() public onlyOwner {
    _unpause();
  }

   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused override {
    super._beforeTokenTransfer(from, to, tokenId);
  }




  function _generateRandNum() internal returns(uint){
  
    // call vrf
    vrfFeeEth = SafeMathChainlink.mul(currentPrice();

    uint randNum = vrf();
    // need to find what the vrf function syntax is
    return randNum % randNumModulus;
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



  function _mintMonster() public payable whenNotPaused {
    
    require(_tokenIdCounter + 1 < maxSupply);
    require(_mintPrice + _vrfFeeEth <= msg.value, "Ether value sent is not correct") 

    uint startingElo = 600;
    uint newTokenId = _GenerateNewTokenId();

    _safeMint(msg.sender, tokenId);

    _tokenIdCounter.increment();
    IdToAddress[newTokenId] = msg.sender;
    IdToElo[newTokenId] = startingElo;
    IdMinted[newTokenId] = true;

    emit NewMonster(newTokenId, IdToElo[newTokenId]);
  }




function _burn(uint256 tokenId) internal Override(ERC721, ERC721Storage) {
    super._burn(tokenId);
  }


/*
set URI
*/

  function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return super.tokenURI(tokenID)
  }

}
