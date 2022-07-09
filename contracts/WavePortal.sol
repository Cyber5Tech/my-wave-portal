// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    //to generate a random number
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    //Store adrress with the last time user waved
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("I am a Smart Contract for sending Waves");
        
        //inital seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public{
        //setting current timestamp to at least 1 minute bigger than prev wave timestamp stored
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait 1m"
        );

        //update user current timestamp
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        //generate a new seed for next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;

        //console.log("Random # generated: %d", seed);

        //give a 50% chance that user wins prize
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Insufficient Balance"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require (success, "Withdrawal Failed");
        }

        emit NewWave(msg.sender, block.timestamp, _message);   
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        //optional: to get totalWaves
        // also updated in run.js
        /*console.log("We have %d total waves", totalWaves);
        return totalWaves;*/
    }
}
