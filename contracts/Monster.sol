// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//->Import from openzeppel lib
  // yellow boxes in order
//See Figjam for list

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


//->Inherit imported libs
contract Monster {

//->using statment for Counters
//->create private counter name: _tokenIdCounter

//->Uncomment after libs imported
//constructor () ERC721("Monster", "MON"){}

//->Create mapping of addresses and tokenId

/*->uncomment pause func w/ onlyOwner modifyer after imports
  function pause() public onlyOwner {
    _pause();
  }
*/

//->create unpause func w/ onlyOwner modifyer (see above)

/*
->create safeMint func w/
onlyowner
should do:
increment counter
internal safe mint
set URI
update mapping
*/

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
  }
*/
}
