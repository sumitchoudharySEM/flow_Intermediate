import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction() {

  let minter:&FlowToken.Minter

  prepare(acct: AuthAccount) {
    self.minter = acct.borrow<&FlowToken.Minter>(from:/storage/newMinter) ??panic("minter is not Present")
    log("minter is present")
    
  }

  execute {
  }
}