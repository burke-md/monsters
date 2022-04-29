import { expect } from "chai";

export const shouldBattle = (): void => {
  //   // to silent warning for duplicate definition of Transfer event
  //   ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.OFF);

  context(`#battle`, async function () {
    it(`should report 0 battle records before any battles have been initiated.`, async function () {
      const numofBattleRecords = await this.battle.connect(this.signers.alice)
      .getNumBattleRecords();

      await expect(numofBattleRecords).to.equal(0);
    });

    it(`should report 2 battle records after two battles have been initiated.`, async function () {
      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      const battle2 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      const numofBattleRecords = await this.battle.connect(this.signers.alice)
      .getNumBattleRecords();

      await expect(numofBattleRecords).to.equal(2);
    });

    it(`should emit 'NewBattleRecord' when initiateBattle() is called.`, async function () {
      await expect(
        this.battle.connect(this.signers.alice)
        .initiateBattle(this.signers.bob.address)
      ).to.emit(this.battle, `NewBattleRecord`);
    });

    it(`should report each battle isComplete as false after initiation but before all battle calculations.`, async function () {
      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      const isBattleComplete = await this.battle.connect(this.signers.alice)
      .getBattleCompletionState(this.signers.alice.address, this.signers.bob.address);

      await expect(isBattleComplete).to.equal(false);
    });
  });
};