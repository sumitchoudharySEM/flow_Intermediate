import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(allowedAmount:UFix64) {

  let administrator:&FlowToken.Administrator

  prepare(acct: AuthAccount,reciverAccount: AuthAccount) {
    self.administrator = acct.borrow<&FlowToken.Administrator>(from:/storage/newflowTokenAdmin) ??panic("Administrator is not Present")
    let minter <- self.administrator.createNewMinter(allowedAmount: allowedAmount)

    reciverAccount.save(<-minter, to: /storage/newMinter)
    log("new minter created properly")
    
  }

  execute {
  }
}