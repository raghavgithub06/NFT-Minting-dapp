# NFT Minting Dapp

The NFT Minting contract is an Ethereum smart contract written in Solidity that implements an ERC-721 compliant non-fungible token (NFT) collection with a theme related to the popular manga and anime series "Attack on Titan" (Shingeki no Kyojin). This documentation provides an overview of the contract's structure and functionality.

## SPDX-License-Identifier
This contract is released under the Unlicense, which essentially means it is in the public domain with no copyright restrictions.

## Prerequisites and Dependencies

This contract relies on various external libraries and smart contracts. The following dependencies are imported at the beginning of the contract:

- `@openzeppelin/contracts/utils/Strings.sol`: A library for working with strings.
- `@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol`: A contract implementing the ERC-721 standard for NFTs with URI storage.
- `@openzeppelin/contracts/utils/Counters.sol`: A library for managing counters.
- `"hardhat/console.sol"`: A library for logging messages during contract execution.
- `Base64.sol`: A custom library for encoding SVG data in base64 format.

## Contract Overview

### Contract Name and Symbol

The contract is named "ShingekiNoKyojinNFT" with the symbol "AOTNFT," representing the "Attack on Titan" NFT collection.

## State Variables

- `_tokenIds`: A counter to keep track of the current token ID.
- `totalNumberOfTokens`: The total number of tokens minted.

## SVG Templates and Word Arrays

The contract includes SVG templates and arrays of words used to generate the random names and SVGs for the NFTs.

## Events

- `NFTMinted`: An event emitted when a new NFT is minted, containing the minter's address and the token ID.

## Functions

### `pickRandomFirstWord(uint256 tokenId)`

This function selects a random first word for generating the NFT name based on the given tokenId.

### `pickRandomSecondWord(uint256 tokenId)`

Similar to `pickRandomFirstWord`, this function selects a random second word for generating the NFT name.

### `pickRandomThirdWord(uint256 tokenId)`

This function selects a random third word for generating the NFT name.

### `random(string memory input)`

An internal pure function to generate a random number based on an input string.

### `makeAnEpicNFT()`

The main function for minting a new NFT. It creates a unique name and SVG for the NFT and mints it to the caller's address.

### `totalTokens()`

A function to query the total number of tokens minted in the collection.

## Usage

1. Deploy the contract to the Ethereum network.
2. Call the `makeAnEpicNFT()` function to mint a new NFT with a unique name and SVG.

## Events

- `NFTMinted`: Emitted when a new NFT is successfully minted. Contains the minter's address and the token ID of the newly minted NFT.

## License

This contract is released under the Unlicense, making it available for use without copyright restrictions.
