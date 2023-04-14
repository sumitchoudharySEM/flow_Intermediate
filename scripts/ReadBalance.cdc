import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

pub fun main(account: Address) {

  let PublicVault:&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}? = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}>()

  if (PublicVault==nil) {

        getAuthAccount(account).save(<- MyToken.createEmptyVault(), to: /storage/Vault)
        getAuthAccount(account).link<&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}>(/public/Vault, target: /storage/Vault)
        log("empty vault created")
        let rePublicVault:&MyToken.Vault{FungibleToken.Balance}? = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance}>()
        log(rePublicVault?.balance)  

    } else{

        log("vault allready exist & is properly linked")
        let CheckVault:&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic} = getAccount(account).getCapability(/public/Vault) 
                        .borrow<&MyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver,MyToken.CollectionPublic}>() ?? panic("noy found")

        if MyToken.vaults.contains(CheckVault.uuid) {
            log(PublicVault?.balance)
            log("this is MyToken")
        } else {
            log("this is not MyToken")
        }
  }               
  
}

//There are two methods I am using to ensure that the token balance I am retrieving belongs to the MyToken type and not some random vault:

//1) I have created a dictionary within MyToken, where I store the UUIDs of all the new vaults or resources created. So, when I read the balance, I first make sure that the vault I am retrieving the balance from belongs to the dictionary of all the MyToken vaults.

//2) I use "let vault <- from as! @MyToken.Vault". This ensures that the fungible token from which I am reading the balance is of type MyToken, and not any other fungible token. 