# Bibi NFT Mint Smart Contract

## Overview

The `bibi::nft_mint` module defines a smart contract on the Aptos Blockchain for minting NFTs within the exclusive Bibi collection. This contract allows users to mint unique NFTs, each associated with a specific identifier and metadata.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Initialization](#initialization)
  - [Minting NFTs](#minting-nfts)
- [Constants](#constants)
- [Error Codes](#error-codes)
- [Structs](#structs)
- [Public Functions](#public-functions)
- [Utility Functions](#utility-functions)

## Getting Started

### Prerequisites

- Aptos Blockchain environment
- Move language compiler and runtime

### Installation

1. Deploy the smart contract on the Aptos Blockchain.
2. Ensure that the `aptos_token` and other required modules are available.

## Usage
### [Firstly, Start your contract](https://github.com/bhutta03/start_aptos_contract/blob/master/README.md)


### Initialization

The smart contract must be initialized by an administrator. This sets up the minting pool and creates the NFT collection.

```move
// Example initialization
admin_address = @bibi;
bibi::nft_mint::init(&admin_address);
````
# Minting NFTs

Users can mint NFTs by invoking the `mint` function, providing the user's signer address and the desired count of NFTs.

```move
// Example minting
user_signer = <user_signer_address>;
count_to_mint = 3;
bibi::nft_mint::mint(&user_signer, count_to_mint);
```
# Constants

- `MODULE_BIBI`: Address of the Bibi NFT Mint module.
- `NAME`: Name of the NFT collection.
- `DESCRIPTION`: Description of the NFT collection.
- `COUNT`: Total number of NFTs in the collection.
- `BASE_URL`: Base URL for generating NFT metadata URLs.
- `COLLECTION_URL`: URL to the external collection description.
  
# Error Codes

- `NO_ADMIN`: Error code indicating that the initialization was not invoked by the correct administrator.
- `ALREADY_MINTED`: Error code indicating an attempt to mint an NFT that has already been minted.
- `EXCEED_MINT_COUNT`: Error code indicating an attempt to mint more NFTs than the allowed limit.
  
# Structs

- `MintInfo`: Structure holding information about the minting pool, minted NFTs, and the current identifier.

# Public Functions

- `init(admin: &signer)`: Initializes the smart contract with an administrator account.
- `mint(user: &signer, count: u64)`: Allows users to mint a specified number of NFTs.

# Utility Functions
- `num_to_str(num: u64)`: Converts a number to a vector of bytes.

