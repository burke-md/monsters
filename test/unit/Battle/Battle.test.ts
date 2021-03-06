import { expect } from "chai";

export const shouldBattle = (): void => {
  //   // to silent warning for duplicate definition of Transfer event
  //   ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.OFF);

  context(`#Happy Path`, async function () {
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

    it(`should emit 'CompletedEvaluation' after a battle has been evaluated.`, async function () {
      const userInput1 = [0, 1];

      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await this.battle
      ._defineBattleMoves(1, userInput1[0], userInput1[1]);

      await this.battle._evaluateBattleMoves(1);

      await expect(
        await this.battle._evaluateBattleMoves(1)
      ).to.emit(this.battle, `CompletedEvaluation`);
    });

    it(`should report each battle isComplete as false after initiation.`, async function () {
      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      const isBattleComplete = await this.battle.connect(this.signers.alice)
      .getBattleCompletionState(1);

      await expect(isBattleComplete).to.equal(false);
    });

    it(`should insert 'moves' into the appropriate BattleInfo stuct.`, async function () {
      const userInput = [1, 2];

      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await this.battle
      ._defineBattleMoves(1, userInput[0], userInput[1]);

      const movesArrFromBattleInfoStruct = await this.battle
      .getBattleMovesArr(1);

      await expect(movesArrFromBattleInfoStruct[0]).to.equal(userInput[0]);
      await expect(movesArrFromBattleInfoStruct[1]).to.equal(userInput[1]);
    });

    it(`should propperly evaluate 'moves'.`, async function () {
      const userInput1 = [0, 1];
      const userInput2 = [3, 0];
      const userInput3 = [2, 2];

      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await this.battle
      ._defineBattleMoves(1, userInput1[0], userInput1[1]);

      const battle2 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await this.battle
      ._defineBattleMoves(2, userInput2[0], userInput2[1]);

      const battle3 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await this.battle
      ._defineBattleMoves(3, userInput3[0], userInput3[1]);

      await this.battle._evaluateBattleMoves(1);
      await this.battle._evaluateBattleMoves(2);
      await this.battle._evaluateBattleMoves(3);

      expect(await this.battle.getBattleResult(1)).to.equal("INITIATOR");
      expect(await this.battle.getBattleResult(2)).to.equal("OPPONENT");
      expect(await this.battle.getBattleResult(3)).to.equal("DRAW");
    });
  });
};