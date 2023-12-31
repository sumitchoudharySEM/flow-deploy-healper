import ConnectNFT from 0x01
import NonFungibleToken from 0x01

transaction {

  prepare(acct: AuthAccount) {
  acct.save(<- ConnectNFT.createEmptyCollection(), to:/storage/ConnectNFTCollection)
  acct.link<&ConnectNFT.Collection{ConnectNFT.CollectionPublic, NonFungibleToken.CollectionPublic}>(/public/ConnectNFTCollection, target:/storage/ConnectNFTCollection )
  }

  execute {
    log("user stored collection inside there account")
  }
}
