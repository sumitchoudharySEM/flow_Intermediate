import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

transaction(reciverAccount: Address,amount:UFix64) {

  let minter:&MyToken.Minter
  let reciverVault:&MyToken.Vault{FungibleToken.Receiver}

  prepare(acct: AuthAccount) {
    self.minter = acct.borrow<&MyToken.Minter>(from:/storage/Minter) ??panic("Minter is not Present")
    
    self.reciverVault = getAccount(reciverAccount).getCapability(/public/Vault)
                        .borrow<&MyToken.Vault{FungibleToken.Receiver}>()
                        ?? panic("vault not found")
  }

  execute {
    let newVault <- self.minter.mintToken(amount:amount)
    self.reciverVault.deposit(from: <-newVault) 
    log("deposit token to reciverAccount")
  }
}