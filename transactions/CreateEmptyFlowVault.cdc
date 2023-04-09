import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction() {

  prepare(acct: AuthAccount) {

    let vault: &FlowToken.Vault? = acct.getCapability(/public/FlowVault)
                                                          .borrow<&FlowToken.Vault>()

    if(vault == nil){
      acct.save(<- FlowToken.createEmptyVault(), to: /storage/FlowVault)
      acct.link<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>(/public/FlowVault, target: /storage/FlowVault)
      log("empty flow vault created")
    } else{
      log("flow vault allready exist & is properly linked")
    }
  }

  execute {
    
  }
}
