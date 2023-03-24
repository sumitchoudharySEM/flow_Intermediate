import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

pub fun main(account: Address) {

  let PublicVault = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance}>()
                        ??panic("vault not found")

  log(PublicVault.balance)                      
  
}