import MyToken from "../contracts/MyToken.cdc"
import FungibleToken from "../contracts/FungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"
import FlowToToken from "../contracts/FlowSwap.cdc"

transaction(amount:UFix64) {

    let signer: AuthAccount

    prepare(acct: AuthAccount) {
        self.signer = acct
    }

    execute {
    SwapToFlow.exchange(signer: self.signer, amount: amount)
    log("swap done")
  }
}