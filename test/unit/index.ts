import { shouldBattle } from "./Battle/Battle.test";
import { shouldMonster } from "./Monster/Monster.test"

describe('Unit tests', async function () {
  before(async function () {
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