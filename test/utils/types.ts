import { Wallet } from "@ethersproject/wallet";
import { Battle, Monster } from "../../typechain"

export interface Signers {
  deployer: Wallet;
  alice: Wallet;
  bob: Wallet;
}