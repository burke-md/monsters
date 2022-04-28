// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//->Import from openzeppel lib
//See Figjam for list
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//->Inherit imported libs
contract Monster is ERC721, Pausable, Ownable {

  constructor() ERC721("Monster", "MON") {}

//->using statment for Counters
//->create private counter name: _tokenIdCounter

//->Create mapping of addresses and tokenId


  function pause() public onlyOwner {
    _pause();
  }


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
