// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//Import from openzeppel lib
//See Figjam for list

//Inherit imported libs
contract Monster {

//using statment for Counters
//create private counter name: _tokenIdCounter

//Uncomment after libs imported
//constructor () ERC721("Monster", "MON"){}


//pause func w/ onlyOwner modifyer

//unpause func w/ onlyOwner modifyer

/*safeMint func w/
onlyowner
should do:
increment counter
internal safe mint
set URI
*/

/*Uncomment the following function 
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

//Uncomment after libs are imported

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
  }
*/
}
