// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./MonsterData.sol";

contract RandomNumberVRF is VRFConsumerBaseV2, Ownable, MonsterData {
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId = 4941;
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    address link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  1;

    uint256 public s_randomNumber;
    uint256 public s_requestId;
    address s_owner;

    address unMintedMonsterAddr;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    function requestRandomWords() internal {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }
    
    function fulfillRandomWords(
        //uint256, /* requestId */
        uint256[] memory randomWords) 
        internal {
            s_randomNumber = (randomWords[0] % getLengthUnmintedMonsters()) + 1;
    }

    function setUnmintedMonsterAddr(
        address _unMintedMonsterContract) 
        external onlyOwner{
            unMintedMonsterAddr = _unMintedMonsterContract;
    }
}
