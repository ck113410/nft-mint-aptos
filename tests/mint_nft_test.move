#[test_only]
module bibi::nft_mint{
    use aptos_framework::signer::address_of;
    use aptos_framework::coin::{ Self, MintCapability};
    use aptos_framework::account;
    use aptos_framework::timestamp;
    use std::string::{Self, utf8};
    use aptos_token::token;

    use bibi::nft_mint;
    use bibi:: bibi_coin::BibiCoin;
    const COLLECTION_CREATOR:address= @0x111;
    const COLLECTION_NAME:vector<u8> = b"collection";

    const NAME: vector<u8> = b"BIBA";
    const DESCRIPTION: vector<u8> = b"BIBA is an exclusive collection of 3333 NFTs on the Aptos Blockchain.";
    const COUNT: u64 = 3333;
    const BASE_URL: vector<u8> = b"https://drive.google.com/file/d/1-UyFs_NTovUnzvY3i-I8g967sGJIposX/view?usp=sharing";
    const COLLECTION_URL: vector<u8> = b"https://drive.google.com/file/d/1-UyFs_NTovUnzvY3i-I8g967sGJIposX/view?usp=sharing";

    struct BibiCoinCapabilities has key{
        mint_cap: MintCapability<BibiCoin>
    }



///
    #[test(admin= @bibi)]
    public fun test_init(
        admin:@signer
    ){
        account::create_account_for_test(address_of(admin));
        create_bibi_coin(admin);
        nft_mint::init(admin, COLLECTION_CREATOR, COLLECTION_NAME );
    }

///


    fun create_bibi_coin(
        admin : &signer
    ){
        let (mint_cap) = coin::initialize<BibiCoinoizCoin>( admin, utf8(b"bibi"), utf8(b"BIBI"), 6, true);
        move_to(admin, BibiCoinCapabilities{
            mint_cap
        });
    }

    #[test(admin= @bibi)]
    public fun test_init(
        admin:@signer
    ){
        account::create_account_for_test(address_of(admin));
        create_bibi_coin(admin);
        nft_mint::init(admin, COLLECTION_CREATOR, COLLECTION_NAME );
    }
}
