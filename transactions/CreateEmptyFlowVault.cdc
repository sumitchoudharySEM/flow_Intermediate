import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction() {

  let vault: &FlowToken.Vault?
  let account:AuthAccount

  prepare(acct: AuthAccount) {

    self.vault = acct.getCapability(/public/FlowVault)
                    .borrow<&FlowToken.Vault>()

    self.account = acct
  }

  execute {
    if(self.vault == nil){
      self.account.save(<- FlowToken.createEmptyVault(), to: /storage/FlowVault)
      self.account.link<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>(/public/FlowVault, target: /storage/FlowVault)
      log("empty flow vault created")
    } else{
      log("flow vault allready exist & is properly linked")
    }
    
  }
}


