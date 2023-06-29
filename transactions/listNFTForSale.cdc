import ConnectNFT from 0x01
import NonFungibleToken from 0x01
import NFTMarketplace from 0x01
import FungibleToken from 0x03
import FlowToken from 0x01

transaction(id: UInt64, price:UFix64) {

  prepare(acct: AuthAccount) {
   let saleCollection = acct.borrow<&NFTMarketplace.SaleCollection>(from: /storage/MySaleCollection)
                            ?? panic("this SaleCollection does not exist")

    saleCollection.listForSale(id: id, price:price)                       
  }

  execute {
    log("user listed their nft for sales")
  }
}