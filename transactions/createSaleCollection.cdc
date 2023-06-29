import ConnectNFT from 0x01
import NonFungibleToken from 0x01
import NFTMarketplace from 0x01
import FungibleToken from 0x03
import FlowToken from 0x01

transaction() {

  prepare(acct: AuthAccount) {
    let ConnectNFTCollection = acct.getCapability<&ConnectNFT.Collection>(/public/ConnectNFTCollection)
    let FlowTokenVault = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReciver)

    acct.save(<- NFTMarketplace.createSaleCollection(ConnectNFTCollection:ConnectNFTCollection, FlowTokenVault :FlowTokenVault), to: /storage/MySaleCollection )
    acct.link<&NFTMarketplace.SaleCollection{NFTMarketplace.SaleCollectionPublic}>(/public/MySaleCollection, target: /storage/MySaleCollection)
  }

  execute {
    log("user stored Salecollection inside there account")
  }
}