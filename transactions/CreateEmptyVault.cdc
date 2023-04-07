import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction() {

  let result:String

  prepare(acct: AuthAccount) {

    let vault: &MyToken.Vault{FungibleToken.Receiver}? = acct.getCapability(/public/Vault)
                                                          .borrow<&MyToken.Vault{FungibleToken.Receiver}>()

    if(vault == nil){
      acct.save(<- MyToken.createEmptyVault(), to: /storage/Vault)
      acct.link<&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}>(/public/Vault, target: /storage/Vault)
      log("empty vault created")
    } else{
      log("vault allready exist & is properly linked")
    }
    self.result ="success"
    
  }

  execute {
    
  }

  post {
    self.result == "success": "success is coming bro"
  }
}