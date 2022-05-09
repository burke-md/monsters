# Monsters
This is a project for the Chainlink Hackathon 2022

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



