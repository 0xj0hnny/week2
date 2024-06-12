## Question:
**Revisit the solidity events tutorial. How can OpenSea quickly determine which NFTs an address owns if most NFTs don’t use ERC721 enumerable? Explain how you would accomplish this if you were creating an NFT marketplace**

To quickly determine which NFTs a given address owns, OpenSea can create a script that accepts an account address and a collection address. The script can use the getPastEvents method to retrieve all Transfer events for the specified collection and account address. By analyzing the from and to fields in these events, the script can construct a list of NFTs currently owned by the address.
