import { Wallet } from "@ethersproject/wallet";

export interface Signers {
  deployer: Wallet;
  alice: Wallet;
  bob: Wallet;
}