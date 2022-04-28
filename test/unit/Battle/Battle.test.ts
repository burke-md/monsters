import { expect, assert } from "chai";
import { Signer } from "ethers";

export const shouldBattle = (): void => {
  //   // to silent warning for duplicate definition of Transfer event
  //   ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.OFF);

  context(`#battle`, async function () {
    it(`should emit 'NewBattleRecord' when initiate battle is called`, async function () {

      await expect(
        this.battle.connect(this.signers.alice)
        .initiateBattle(this.signers.bob.address)
      ).to.emit(this.battle, `NewBattleRecord`);
    });
    
  });
};