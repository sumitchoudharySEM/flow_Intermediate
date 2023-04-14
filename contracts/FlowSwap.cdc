import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

pub contract SwapToFlow {

  pub var lastSwapTimeOptional: UFix64?
  pub var lastSwapTime: UFix64
  pub var lastSwapTimeD: {Address: UFix64}

  pub fun exchange(signer:AuthAccount,amount:UFix64){
  
    let myTokenVault = signer.borrow<&MyToken.Vault>(from: /storage/Vault)
      ?? panic("Could not borrow MyToken Vault from signer")

    let flowVault = signer.borrow<&FlowToken.Vault>(from: /storage/FlowVault)
      ?? panic("Could not borrow FlowToken Vault from signer")  

    let minterRef = self.account.getCapability<&MyToken.Minter>(/public/Minter).borrow()
      ?? panic("Could not borrow reference to MyToken Minter")

    let autherVault = self.account.getCapability<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>(/public/FlowVault).borrow()
      ?? panic("Could not borrow reference to FlowToken Vault")  
    
    let withdrawalAmount <- flowVault.withdraw(amount: amount)
    log("withdrawalAmount let init")
    autherVault.deposit(from: <-withdrawalAmount)
    log("withdrawalAmount transfered")
    
    let userAddress = signer.address
    self.lastSwapTimeOptional = self.lastSwapTimeD[userAddress]
    let currentTime = getCurrentBlock().timestamp
    log("geted all times")

    if (self.lastSwapTimeOptional == nil) {
      SwapToFlow.lastSwapTime == 1.0
    } else{
      SwapToFlow.lastSwapTime == self.lastSwapTimeOptional
    }
    log("condition 1 checked")
    
    let timeSinceLastSwap = currentTime - self.lastSwapTime
    let mintAmount = 2.0 * UFix64(timeSinceLastSwap)
    log("mint ammount calculated")

    let newMyTokenVault  <- minterRef.mintToken(amount: mintAmount)
    log("prapere to mytoken minting")
    myTokenVault.deposit(from: <- newMyTokenVault)
    log("mytoken minted")

    if (self.lastSwapTimeD.containsKey(userAddress)) {
      self.lastSwapTimeD.remove(key: userAddress)
    }
    self.lastSwapTimeD.insert(key: userAddress, timeSinceLastSwap)
    log("contract done and clear")
  }

  init(){
    self.lastSwapTime = 1.0
    self.lastSwapTimeD ={0x01: 1.0}
    self.lastSwapTimeOptional = nil
  }
  
}





