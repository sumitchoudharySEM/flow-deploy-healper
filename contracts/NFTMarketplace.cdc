import ConnectNFT from 0x01
import NonFungibleToken from 0x01
import FungibleToken from 0x03
import FlowToken from 0x01

pub contract NFTMarketplace {

  pub resource SaleCollection{

    pub var forSale: {UInt64: UFix64}

    pub let ConnectNFTCollection: Capability<&ConnectNFT.Collection>
    pub let FlowTokenVault :Capability<&FlowToken{FungibleToken.Receiver}>

    pub fun listForSale(id: UInt64, price:UInt64){
      pre{
        price >= 0: " it dont make sence"
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

    init(_ConnectNFTCollection: Capability<&ConnectNFT.Collection>,_FlowTokenVault :Capability<&FlowToken{FungibleToken.Receiver}>){
      self.forSale = {}
      self.ConnectNFTCollection = _ConnectNFTCollection
      self.FlowTokenVault = _FlowTokenVault
    }
  }

  pub fun createSaleCollection(ConnectNFTCollection: Capability<&ConnectNFT.Collection>,FlowTokenVault :Capability<&FlowToken{FungibleToken.Receiver}>) :@SaleCollection {
   return <- create SaleCollection(_ConnectNFTCollection:ConnectNFTCollection, _FlowTokenVault :FlowTokenVault)
  }

  init(){
     
  }
}