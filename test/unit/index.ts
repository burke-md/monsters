import { waffle } from "hardhat";
import { unitMonsterFixture } from "../utils/fixtures";
import{ unitBattleFixture } from "../utils/fixtures";
import { Signers } from "../utils/types";
import { shouldBattle } from "./Battle/Battle.test";
import { shouldHandleError } from "./Battle/BattleError.test"
import { shouldMonster } from "./Monster/Monster.test"

describe('Unit tests', async function () {
  before(async function () {
    const wallets = waffle.provider.getWallets();
    this.signers = {} as Signers;
    this.signers.deployer = wallets[0];
    this.signers.alice = wallets[1];
    this.signers.bob = wallets[2];

    this.loadFixture = waffle.createFixtureLoader(wallets);
  });

  describe('Battle', async function () {
    beforeEach(async function () {
      const { battle } = await this.loadFixture(unitBattleFixture);
      this.battle = battle;
      //this.mocks = {} as Mocks;
    });
    shouldBattle();
    shouldHandleError();
  });
  
  describe('Monster', async function () {
    beforeEach(async function () {
      //load fixture and mocks
    });
    shouldMonster();
  });
});