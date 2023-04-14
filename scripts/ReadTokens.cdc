import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"

pub fun main(user: Address): {UInt64: UFix64} {

  let authAccount: AuthAccount = getAuthAccount(user)
  let vaults: {UInt64: UFix64} = {}

  let iterationFunction :((StoragePath, Type): Bool) = fun( path:StoragePath, type: Type): Bool {
    if type.isSubtype(of: Type<@FungibleToken.Vault>()) {
        let vaultRef = authAccount.borrow<&FungibleToken.Vault>(from: path)!
        let balance = vaultRef.balance
        vaults.insert(key: vaultRef.uuid, balance)
    }
    return true
  }

  authAccount.forEachStored(iterationFunction)

  return vaults
}