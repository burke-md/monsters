# Monsters

This is a project for the Chainlink Hackathon 2022


## The battle contract

The following are the major steps involved in each battle. There are several 
helper functions omitted for simplicity of explaining the process.


- initiateBattle --This will be called publically by the "initiator", naming 
    the "opponent". This creates a record of the battle without entering any 
    specific information.

- commitBattleMovesHash -- This will be called by individual players to commit 
    hashed moves array. See instructions for this.
    
- revealBattleMoves --This validates, reveals and enters the moves into the 
    battle record. The moves can now be viewed.

- _evaluateBattleMoves --This function determins the outcome and calls another
    function : _updateBattleInfoResult

- _updateBattleInfoResult --This enters the "result" of the battle into the 
    record that was created at the begining of this sequence.

- _evaluateMonsterElo --This determins how many points to give to the winning
    monster. Somewhat akin to XP, it will only increment positively. 

- _updateWinner --This calls a function in the Monster contract updating the 
    ELO points mapped to each monsters token ID.

## Working with this repo

The testing infrastructure is written in typescript to remove several potential 
issues. Unfortunately typing is not available in all the libs being used. 
To combat this a system has been developed using the '@typechain/hardhat' 
package which uses the ABI of compiled contracts to make this information 
available throughout the project. 

If you are experiences an error related to the import of typechain follow these 
steps:

- Delete the artifacts, cache and typechain(if it exists) directories at the 
  top level. These are generated files.

- Run ```npx hardhat compile``` in the terminal. 
  This will re-generate those directories with the appropriate files. 



