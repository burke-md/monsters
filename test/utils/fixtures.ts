import { Fixture, MockContract } from "ethereum-waffle";
import { ContractFactory, Wallet } from "ethers";
import { ethers } from "hardhat";
import { Monster } from "../../typechain";

type UnitMonsterFixtureType = {
  monster: Monster;
}

export const unitMonsterFixture: Fixture<UnitMonsterFixtureType> = async (signers: Wallet[]) => {
  const deployer: Wallet = signers[0];

  const monsterFactory: ContractFactory = await ethers.getContractFactory('Monster');

  const monster: Monster = (await monsterFactory
    .connect(deployer)
    .deploy()) as Monster;

    await monster.deployed();

    return { monster };
};