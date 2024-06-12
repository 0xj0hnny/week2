## Question:
**How does ERC721A save gas?**
This token standard was developed by the Azuki team, aim to resolve the problem of significatnt gas cost during a popular NFT collection sale. The team achieve the gas saving in a few technique.

- allow user to mint multiple NFTs in a single transaction. 
- tokenIds follows in serial order, which allows the contract to recording a single ownership datapoint for a range of consecutive tokens. As a result, this will reduce the number of storage write. 
- Optimize transfer process by only updating the starting point of the new ownership range.instead of update individual NFT.


## Question:
**Where does it add cost?**
In contract to the ERC721A standard, it's costly to operate things on a ERC721 contract because: 
- user needs to create multiple transactions during the mint process if user wants to buy multiple NFTs
- Storage NFT ownership individually for each tokenID. As the result, this will increase the write operation, especially minting multiple NFTs.
- Multiple operation involving transfer NFT to new owner. 
