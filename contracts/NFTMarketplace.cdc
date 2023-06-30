import ConnectNFT from "./connectNFT.cdc"
import NonFungibleToken from 0x631e88ae7f1d7c20
import FungibleToken from "./FungibleToken.cdc"
import FlowToken from "./FlowToken.cdc"
//0x7e60df042a9c0868

pub contract NFTMarketplace {

  pub resource interface SalecollectionPublic {
    pub fun purchase(id:UInt64, recipentCollection: &ConnectNFT.Collection{NonFungibleToken.CollectionPublic}, payment:@FlowToken.Vault)
    pub fun getPrice(id:UInt64):UFix64
    pub fun getIDs(): [UInt64]
  }

  pub resource SaleCollection:SalecollectionPublic{

    pub var forSale: {UInt64: UFix64}

    pub let ConnectNFTCollection: Capability<&ConnectNFT.Collection>
    pub let FlowTokenVault :Capability<&FlowToken.Vault{FungibleToken.Receiver}>

    pub fun listForSale(id: UInt64, price:UFix64){
      pre{
        price >= 0.0: " it dont make sence"
        self.ConnectNFTCollection.borrow()!.getIDs().contains(id): "you dont own this nft"
      }
      self.forSale[id] = price
    }

    pub fun unlistFromSale(id: UInt64){
      self.forSale.remove(key: id)
    }

    pub fun purchase(id:UInt64, recipentCollection: &ConnectNFT.Collection{NonFungibleToken.CollectionPublic}, payment:@FlowToken.Vault){
      pre {
        payment.balance == self.forSale[id] :"the price is not valid"
      }
      let nft <- self.ConnectNFTCollection.borrow()!.withdraw(withdrawID: id)
      recipentCollection.deposit(token: <-nft)
      self.FlowTokenVault.borrow()!.deposit(from: <- payment)
    }

    pub fun getPrice(id:UInt64):UFix64{
      return self.forSale[id]!
    }

    pub fun getIDs(): [UInt64]{
      return self.forSale.keys
    }

    init(_ConnectNFTCollection: Capability<&ConnectNFT.Collection>,_FlowTokenVault :Capability<&FlowToken.Vault{FungibleToken.Receiver}>){
      self.forSale = {}
      self.ConnectNFTCollection = _ConnectNFTCollection
      self.FlowTokenVault = _FlowTokenVault
    }
  }

  pub fun createSaleCollection(ConnectNFTCollection: Capability<&ConnectNFT.Collection>,FlowTokenVault :Capability<&FlowToken.Vault{FungibleToken.Receiver}>) :@SaleCollection {
   return <- create SaleCollection(_ConnectNFTCollection:ConnectNFTCollection, _FlowTokenVault :FlowTokenVault)
  }

  init(){
     
  }
}