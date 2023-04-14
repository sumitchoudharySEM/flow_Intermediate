import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction() {

  let vault: &MyToken.Vault{FungibleToken.Balance,FungibleToken.Provider, FungibleToken.Receiver,MyToken.CollectionPublic}?
  let account: AuthAccount

  prepare(acct: AuthAccount) {

    self.vault = acct.getCapability(/public/Vault)
                .borrow<&MyToken.Vault{FungibleToken.Balance,FungibleToken.Provider, FungibleToken.Receiver,MyToken.CollectionPublic}>()

    self.account = acct
  }

  execute {
    if(self.vault == nil){
      self.account.save(<- MyToken.createEmptyVault(), to: /storage/Vault)
      self.account.link<&MyToken.Vault{FungibleToken.Balance,FungibleToken.Provider, FungibleToken.Receiver,MyToken.CollectionPublic}>(/public/Vault, target: /storage/Vault)
      log("empty vault created")
    } else{
      log("vault allready exist & is properly linked")
    }
  }
}