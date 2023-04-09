import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub fun main(account: Address) {

  let PublicVault = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance}>()
                        ??panic("vault not found")

  if MyToken.vaults.contains(PublicVault.uuid) {
    log(PublicVault.balance)
     log("this is MyToken")
  } else {
    log("this is not MyToken")
  }   
}