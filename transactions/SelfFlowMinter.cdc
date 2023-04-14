import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(allowedAmount:UFix64) {

  let administrator:&FlowToken.Administrator

  prepare(acct: AuthAccount) {
    self.administrator = acct.borrow<&FlowToken.Administrator>(from:/storage/newflowTokenAdmin) ??panic("Administrator is not Present")
    let minter <- self.administrator.createNewMinter(allowedAmount: allowedAmount)

    acct.save(<-minter, to: /storage/FlowMinter)
    acct.link<&FlowToken.Minter>(/public/FlowMinter, target: /storage/FlowMinter)
    log("new minter created properly to self")
    
  }

  execute {
  }
}