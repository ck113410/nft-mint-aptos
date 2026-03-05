// The module bibi::nft_mint defines a smart contract for minting NFTs on the Aptos Blockchain.
module bibi::nft_mint {
    use std::signer::address_of;
    use std::string::{Self, String, utf8};
    use aptos_token::token;
    use aptos_std::simple_map;
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    //Define constant values for the module
    const MODULE_BIBI: address = @bibi;

    const NAME: vector<u8> = b"BIBA";
    const DESCRIPTION: vector<u8> = b"BIBA is an exclusive collection of 3333 NFTs on the Aptos Blockchain.";
    const COUNT: u64 = 3333;
    const BASE_URL: vector<u8> =  b"https://drive.google.com/file/d/1-UyFs_NTovUnzvY3i-I8g967sGJIposX/view?usp=sharing";
    const COLLECTION_URL: vector<u8> = b"https://drive.google.com/file/d/1-UyFs_NTovUnzvY3i-I8g967sGJIposX/view?usp=sharing";

    //Error Code
    const NO_ADMIN:u64 = 1;
    const ALREADY_MINTED: u64 = 2;
    const EXCEED_MINT_COUNT:u64 = 3;

    // Define a struct to hold minting information
    struct MintInfo has key{
        pool_cap: account::SignerCapability,
        minted: simple_map::SimpleMap<address, u64>,
        cid: u64
    }

    // Initialize the smart contract with an admin account
    public entry fun init(admin:&signer){
        assert!(address_of(admin) == MODULE_BIBI, NO_ADMIN); // Ensure that the admin invoking the initialization is the correct admin

        // Create a resource account for the minting pool
        let ( pool_signer, pool_signer_cap) = account::create_resource_account(admin, b"mint_nft");

        // Initialize the MintInfo struct and move it to the admin's storage
        move_to(admin, MintInfo{
            pool_cap: pool_signer_cap, 
            minted: simple_map::create<address, u64>(),
            cid: 0
        });

        // Create an NFT collection using the token module
        token::create_collection(
            &pool_signer,
            utf8(NAME),
            utf8(DESCRIPTION),
            utf8(COLLECTION_URL),
            COUNT,
            vector<bool>[false, false, false]
        );
    }

    // Mint NFTs for a user
    public entry fun mint(user: &signer, count: u64) acquires MintInfo {
        let user_addr = address_of(user);
        let mint_info = borrow_global_mut<MintInfo>(MODULE_BIBI);
        let cid = mint_info.cid;
        assert!((cid + count) <= COUNT, EXCEED_MINT_COUNT);

        coin::transfer<AptosCoin>(user, MODULE_BIBI, 150000000 * count);

        token::initialize_token_store(user);
        token::opt_in_direct_transfer(user, true);

        let pool_signer = account::create_signer_with_capability(&mint_info.pool_cap);

        let i = 0;
        while( i < count){
            let token_name = utf8(NAME);
            string::append( &mut token_name, utf8(b" #"));
            string::append( &mut token_name, utf8(num_to_str(cid + i)));

            let token_uri = utf8(BASE_URL);
            string::append(&mut token_uri, utf8(b"/"));
            string::append(&mut token_uri, utf8(num_to_str(cid + i)));
            string::append(&mut token_uri, utf8(b".json"));

            // Create TokenData and mint the NFT to the user
            let token_data_id = token::create_tokendata(
                &pool_signer,
                utf8(NAME),
                token_name, // token_name
                utf8(DESCRIPTION),  //token_desc
                1,          //maximum
                token_uri, // token uri
                MODULE_BIBI,  //royalty_payee_address
                1000, //royalty_points_denominator
                44, //royalty_points_numerator
                token::create_token_mutability_config(&vector<bool>[false, false, false, false, false]),
                vector<String>[], // property_keys in tokendata
                vector<vector<u8>>[], //property_values in tokendata
                vector<String>[] // property_types
            );
            token::mint_token_to(&pool_signer, user_addr, token_data_id, 1);
            i = i + 1;
        };

        // Update the minting counter in MintInfo
        mint_info.cid = cid + count;
    }
    // Convert a number to a vector of bytes
    public fun num_to_str(num: u64):vector<u8>{
        let vec_data = vector::empty<u8>();
        while(true){
            vector::push_back( &mut vec_data, (num % 10 + 48 as u8));
            num = num / 10;
            if (num == 0){
                break
            }
        };
        vector::reverse<u8>(&mut vec_data);
        vec_data
    }
    
}
