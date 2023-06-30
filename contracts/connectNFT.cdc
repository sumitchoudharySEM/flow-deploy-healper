import NonFungibleToken from 0x631e88ae7f1d7c20

pub contract ConnectNFT: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub resource NFT:NonFungibleToken.INFT {
      pub let id: UInt64
      pub let ipfshash: String
      pub let metadata: {String: String}

      init(_ipfshash:String, _metadata: {String:String}){
        self.id = ConnectNFT.totalSupply
        ConnectNFT.totalSupply = ConnectNFT.totalSupply +1
        self.ipfshash = _ipfshash
        self.metadata = _metadata
      }
    }

    pub resource interface CollectionPublic{
      pub fun borrowEntireNFT(id:UInt64):&ConnectNFT.NFT
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic{

      pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

      pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
        let token <- self.ownedNFTs.remove(key:withdrawID ) ?? panic("this nft does not exist")
        emit Withdraw(id: withdrawID, from: self.owner?.address)
        return <-token
      }

      pub fun deposit(token: @NonFungibleToken.NFT){
        let mytoken <- token as! @ConnectNFT.NFT
        emit Deposit(id: mytoken.id,to: self.owner?.address )
        self.ownedNFTs[mytoken.id] <-! mytoken
      }

      pub fun getIDs(): [UInt64]{
        return self.ownedNFTs.keys
      }

      pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
        return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
      }

      pub fun borrowEntireNFT(id:UInt64) :&ConnectNFT.NFT{
        let refrence = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT?
        return refrence as! &ConnectNFT.NFT
      }

      init(){
        self.ownedNFTs <- {}
      }

      destroy(){
        destroy self.ownedNFTs
      }
    }

  pub fun createEmptyCollection() : @NonFungibleToken.Collection{
    return <- create Collection()
  }  

  pub fun createToken(ipfshash:String, metadata:{String: String}) :@ConnectNFT.NFT{
    return <- create NFT(_ipfshash :ipfshash, _metadata:metadata)
  }

  init(){
    self.totalSupply =0
  }

}
