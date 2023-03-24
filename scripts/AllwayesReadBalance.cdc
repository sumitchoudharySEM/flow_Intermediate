import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

pub fun main(account: Address): UFix64? {

  let PublicVault:&MyToken.Vault{FungibleToken.Balance}? = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance}>()

  if (PublicVault==nil) {
        getAuthAccount(account).save(<- MyToken.createEmptyVault(), to: /storage/Vault)
        getAuthAccount(account).link<&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}>(/public/Vault, target: /storage/Vault)
        log("empty vault created")
        let rePublicVault:&MyToken.Vault{FungibleToken.Balance}? = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance}>()
        return rePublicVault?.balance     
    } else{
        log("vault allready exist & is properly linked")
        return PublicVault?.balance     
  }                       

                   
  
}