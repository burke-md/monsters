// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract MonsterHelpers{

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
    function tokenURI(uint256 _tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
      return super.tokenURI(_tokenId)
    }
}