import ConnectNFT from 0x01

transaction(ipfshash:String, metadata:{String: String}) {

  prepare(acct: AuthAccount) {
    let collection = acct.borrow<&ConnectNFT.Collection>(from: /storage/ConnectNFTCollection)
                ??panic("no such collection found")
    let nft <- ConnectNFT.createToken(ipfshash:ipfshash, metadata:metadata)
    collection.deposit(token: <- nft)
  }

  execute {
    log("a new nft is created and stored in users account")
  }
}