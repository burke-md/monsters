// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//See Figjam for list
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/MonsterHelpers.sol";
import "./utils/RandomNumberVRF.sol";
import "./utils/MonsterData.sol";

abstract contract Monster is Ownable,
    ERC721, 
    MonsterData,
    ERC721Burnable, 
    ERC721URIStorage, 
    MonsterHelpers,
    RandomNumberVRF {

    constructor () ERC721("Monster", "MON") {}

    using Counters for Counters.Counter; 
    event NewMonster(uint monsterId, uint Elo);
    
    //---------------------------------------------------------------------------\\
    //-----------------------------Access Control--------------------------------\\

    /**
    *   @notice onlyBattle modifier will ensure only the battle contract calls 
    *   the update ELO function.
    */

    modifier onlyBattle {
        require(msg.sender == battleContractAddress,
            "MONSTER: Confirm battle address has been set by owner and that this function is only being called from the Battle contract.");
        _;
    }

    //---------------------------------------------------------------------------\\
    //---------------------------------------------------------------------------\\

     function mintMonster() public payable whenNotPaused {

        require((_tokenIdCounter.current() + 1) <= maxSupply,
                "MONSTERS: Mint would exceed maxSupply");

        uint newTokenId = _GenerateNewTokenId();

        _safeMint(msg.sender, newTokenId);

        _tokenIdCounter.increment();
        IdToElo[newTokenId] = startingElo;
        removeUnmintedId(newTokenId - 1 - _tokenIdCounter.current());

        _setFullTokenURI(newTokenId);

        emit NewMonster(newTokenId, IdToElo[newTokenId]);
    }

    function _GenerateNewTokenId() internal returns(uint) {

        uint randNum = _generateRandNum();
        uint tokenIndex = (randNum / randNumModulus) * (unmintedMonsters.length); // range: 0 to (unmintedMonsters.length - 1)
        uint tokenId = unmintedMonsters[tokenIndex];

        return tokenId;
    }

    function _generateRandNum() internal returns(uint){
        requestRandomWords();
        return _randomNumber;
    }

    function _getLevel(uint256 tokenId) internal view returns (string memory) {

        uint elo = IdToElo[tokenId];
        string memory level;

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

//---------------------------------------------------------------------------\\
//--------------------------------External-----------------------------------\\

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

        //Will check and update level as needed.
        _setFullTokenURI(monsterId);
    }

    /** @notice checkOwnership is a funtion to be called by the Battle contract
    *   to insure only the owners of monsters and battling with them.
    *   @ require checkOwnership can only be called by the Battle contract. 
    */

    function checkOwnership(
        address _owner, 
        uint256 monsterId) 
        external view
        onlyBattle
        returns (bool isValid) {
            
            if (ownerOf(monsterId) == _owner) return true;

            return false;
    }

//---------------------------------------------------------------------------\\
//------------------------------Overrides------------------------------------\\

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override {
            super._beforeTokenTransfer(from, to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) 
        internal 
        override 
        (ERC721, ERC721URIStorage) {
            super._burn(tokenId);
  }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs/QmZLnaUGeUDm2HJmNeMhPh42GCexHbrQZGdjsTtqjUCGza/";
    }
}
