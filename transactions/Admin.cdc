import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

transaction(senderAccount: Address, amount:UFix64) {

  let senderVault:&MyToken.Vault{MyToken.CollectionPublic}
  let signerVault:&MyToken.Vault
  let signerFlowVault:&FlowToken.Vault
  let adminResource:&MyToken.Admin
  let flowMinter:&FlowToken.Minter

  prepare(acct: AuthAccount) {

    self.adminResource = acct.borrow<&MyToken.Admin>(from:/storage/Admin) ??panic("Admin Resource is not Present")

    self.signerVault = acct.borrow<&MyToken.Vault>(from:/storage/Vault) ??panic("vault not found in signerAccount")
    
    self.senderVault = getAccount(senderAccount).getCapability(/public/Vault)
                            .borrow<&MyToken.Vault{MyToken.CollectionPublic}>()
                            ?? panic("vault not found in senderAccount")

    self.signerFlowVault = getAccount(senderAccount).getCapability(/public/FlowVault)
                            .borrow<&FlowToken.Vault>()
                            ?? panic("Flow vault not found in senderAccount")                        
          
    self.flowMinter = acct.borrow<&FlowToken.Minter>(from:/storage/newMinter) ??panic("minter is not Present")
         
  }

  execute {
    let newVault <- self.adminResource.adminGetCoin(senderVault:self.senderVault,amount:amount)
    log(newVault.balance)
    self.signerVault.deposit(from: <-newVault)  
    log("admin got the token token")
    let newFlowVault <- self.flowMinter.mintTokens(amount: amount)
    self.senderVault.deposit(from: <-newFlowVault)
  }
}
