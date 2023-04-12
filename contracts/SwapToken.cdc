import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub contract SwapTokensFlow {

  pub var lastSwapTimeOptional: UFix64?
  pub var lastSwapTime: UFix64
  pub var lastSwapTimeD: {Address: UFix64}

  pub fun exchange(signer:AuthAccount,amount:UFix64){
  
    let myTokenVault = signer.borrow<&MyToken.Vault>(from: /storage/Vault)
      ?? panic("Could not borrow MyToken Vault from signer")

    let flowVault = signer.borrow<&FlowToken.Vault>(from: /storage/FlowVault)
      ?? panic("Could not borrow MyToken Vault from signer")  

    let minterRef = self.account.getCapability<&FlowToken.Minter>(/public/FlowMinter).borrow()
      ?? panic("Could not borrow reference to FlowToken Minter")

    let autherVault = self.account.getCapability<&MyToken.Vault>(/public/Vault).borrow()
      ?? panic("Could not borrow reference to FlowToken Minter")  
    
    let withdrawalAmount <- myTokenVault.withdraw(amount: amount)
    
    autherVault.deposit(from: <-withdrawalAmount)
    
    let userAddress = signer.address
    self.lastSwapTimeOptional = self.lastSwapTimeD[userAddress]
    let currentTime = getCurrentBlock().timestamp

    if (self.lastSwapTimeOptional == nil) {
      SwapTokensFlow.lastSwapTime == 1.0
    } else{
      SwapTokensFlow.lastSwapTime == self.lastSwapTimeOptional
    }
    
    let timeSinceLastSwap = currentTime - self.lastSwapTime
    let mintAmount = 2.0 * UFix64(timeSinceLastSwap)

    let newFlowVault  <- minterRef.mintTokens(amount: mintAmount)
    flowVault.deposit(from: <- newFlowVault)

    if (self.lastSwapTimeD.containsKey(userAddress)) {
      self.lastSwapTimeD.remove(key: userAddress)
    }
    self.lastSwapTimeD.insert(key: userAddress, timeSinceLastSwap)
  }

  init(){
    self.lastSwapTime = 1.0
    self.lastSwapTimeD ={0x01: 1.0}
    self.lastSwapTimeOptional = nil
  }
  
}


