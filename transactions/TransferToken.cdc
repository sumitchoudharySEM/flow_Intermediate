import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

transaction(reciverAccount: Address, amount:UFix64) {

  let reciverVault:&MyToken.Vault{FungibleToken.Receiver}
  let signerVault:&MyToken.Vault

  prepare(acct: AuthAccount) {
    self.signerVault = acct.borrow<&MyToken.Vault>(from:/storage/Vault) ??panic("vault not found in senderAccount")
    
    self.reciverVault = getAccount(reciverAccount).getCapability(/public/Vault)
                            .borrow<&MyToken.Vault{FungibleToken.Receiver}>()
                            ?? panic("vault not found in reciverAccount")

                   
  }

  execute {
    self.reciverVault.deposit(from: <- self.signerVault.withdraw(amount:amount)) 
    log("transfered token")
  }
}