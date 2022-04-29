import { expect } from "chai";

export const shouldHandleError = (): void => {
  //   // to silent warning for duplicate definition of Transfer event
  //   ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.OFF);

  context(`#Handle Errors`, async function () {
    it(`should not insert invalid 'moves' into the BattleInfo stuct`, async function () {
      const userInput = ["LEGS", "ARM"];

      const battle1 = await this.battle
      .connect(this.signers.alice)
      .initiateBattle(this.signers.bob.address);

      await expect(this.battle
      ._defineBattleMoves(1, userInput[0], userInput[1])).to.be.reverted;
    });
  });
};