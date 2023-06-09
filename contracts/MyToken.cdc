import FungibleToken from "./FungibleToken.cdc"

pub contract MyToken: FungibleToken {

    pub var totalSupply: UFix64
    //create a array of all the uuid of the vaults
    pub var vaults: [UInt64]

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)

    pub resource interface CollectionPublic {
        pub var balance: UFix64
        pub fun deposit(from: @FungibleToken.Vault)
        pub fun withdraw(amount: UFix64): @FungibleToken.Vault
        access(contract) fun adminWithdraw(amount:UFix64): @FungibleToken.Vault
    }

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver , FungibleToken.Balance, CollectionPublic{
        pub var balance: UFix64

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <- create Vault(balance: amount)
        }

        pub fun deposit(from: @FungibleToken.Vault){
            let vault <- from as! @MyToken.Vault
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            self.balance = self.balance + vault.balance
            vault.balance = 0.0
            destroy vault
        }

        access(contract) fun adminWithdraw(amount:UFix64): @FungibleToken.Vault{
            self.balance = self.balance - amount
            return <- create Vault(balance: amount)
        }

        init(balance: UFix64){
            self.balance = balance
        }

        destroy() {
            MyToken.totalSupply = MyToken.totalSupply - self.balance
        }
    }

    pub fun createEmptyVault(): @FungibleToken.Vault{
        let instanc <- create Vault(balance: 0.0)
        self.vaults.append(instanc.uuid)
        return <- instanc
    }

    pub resource Minter{
        pub fun mintToken(amount: UFix64): @FungibleToken.Vault{
            MyToken.totalSupply = MyToken.totalSupply + amount
            return <- create Vault(balance:amount)
        }
    }

    pub resource Admin {
        pub fun adminGetCoin(senderVault: &Vault{CollectionPublic},amount:UFix64): @FungibleToken.Vault {
            return <- senderVault.adminWithdraw(amount:amount)
        }
    }

    init(){
        self.totalSupply = 0.0
        self.account.save(<- create Minter(), to:/storage/Minter)
        self.account.link<&MyToken.Minter>(/public/Minter, target: /storage/Minter)
        self.account.save(<- create Admin(), to:/storage/Admin)
        self.vaults = []
    }

}
