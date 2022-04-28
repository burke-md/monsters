import { waffle } from "hardhat";
import { Signers } from "../utils/types";
import { shouldBattle } from "./Battle/Battle.test";
import { shouldMonster } from "./Monster/Monster.test"

describe('Unit tests', async function () {
  before(async function () {
    const wallets = waffle.provider.getWallets();
    this.signers = {} as Signers;
    this.signers.deployer = wallets[0];
    this.signers.alice = wallets[1];
    this.signers.bob = wallets[2];
  });

  describe('Battle', async function () {
    beforeEach(async function () {
      //load fixture and mocks
    });
    shouldBattle();
  });
  
  describe('Monster', async function () {
    beforeEach(async function () {
      //load fixture and mocks
    });
    shouldMonster();
  });
});