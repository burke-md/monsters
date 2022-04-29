// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//See Figjam for list
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//->Inherit imported libs
contract Monster is ERC721,ERC721Pausable,ERC721Burnable,ERC721URIStorage,Ownable,Counters {

//->using statment for Counters
//->create private counter na
 

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
    // Counters.Counter is a pre-defined struct variable format, we're defining one Counters.counter called _tokenIdCounter

//constructor () ERC721("Monster", "MON"){}
  constructor () public ERC721("Monster", "MON") {} 
    // constructor() is a special function type declared once, used to initialized contract state

//->Create mapping of addresses and tokenId

  mapping (uint => address) IdToAddress;

//->uncomment pause func w/ onlyOwner modifyer after imports
  function pause() public onlyOwner {
    _pause();
  }

//->create unpause func w/ onlyOwner modifyer (see above)
  function unpause() public onlyOwner {
    _unpause();
  }

/*
->create safeMint func w/
onlyowner
should do:
increment counter
internal safe mint
set URI
update mapping
*/



  function _vrfToTokenId(uint _vrfNum) internal returns(uint){
    
    /* 
    input VRF number
    convert to tokenId
    check tokenId has not already been minted - maybe separate function
    output tokenId
    */

    return _tokenId
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
  }
*/
}
