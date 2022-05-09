import { Fixture, MockContract } from "ethereum-waffle";
import { ContractFactory, Wallet } from "ethers";
import { ethers } from "hardhat";
import { Battle, Monster } from "../../typechain";

type UnitMonsterFixtureType = {
  monster: Monster;
}

type UnitBattleFixtureType = {
  battle: Battle;
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

export const unitBattleFixture: Fixture<UnitBattleFixtureType> = async (signers: Wallet[]) => {
  const deployer: Wallet = signers[0];

  const battleFactory: ContractFactory = await ethers.getContractFactory('Battle');

  const battle: Battle = (await battleFactory
    .connect(deployer)
    .deploy()) as Battle;

    await battle.deployed();

    return { battle };
};