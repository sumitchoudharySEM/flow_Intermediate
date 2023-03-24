import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

transaction(amount:UFix64) {

  let minter: &MyToken.Minter

  prepare(acct: AuthAccount) {

    self.minter = acct.borrow<&MyToken.Minter>(from:/storage/Minter) ??panic("Minter is not Present")

  }

  execute {
    let newVault <- self.minter.mintToken(amount:amount)
    log(newVault.balance)
    destroy newVault
  }
}