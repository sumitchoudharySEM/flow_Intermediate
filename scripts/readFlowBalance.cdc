import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub fun main(account: Address): UFix64? {

  let PublicVault:&FlowToken.Vault{FungibleToken.Balance}? = getAccount(account).getCapability(/public/FlowVault) 
                        .borrow<&FlowToken.Vault{FungibleToken.Balance}>() ??panic("flow vault not exist")

    return PublicVault?.balance     
} 