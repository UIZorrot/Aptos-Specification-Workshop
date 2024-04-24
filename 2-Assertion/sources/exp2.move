module section2::exp2 {
    use std::debug::print;

    struct CoinA has key {
        balance: u64,
    }

    fun add(a: u64, b: u64) {
        assert!((a as u128) * (b as u128) > 0, 666);

        let c = a + b;
        spec {
            assert c == a + b;
        };

        print(&c);
    }

    fun get_balance(owner: address): u64 acquires CoinA {
        assert!(exists<CoinA>(owner), 999);

        borrow_global<CoinA>(owner).balance
    }

    fun get_balance_1(owner: address, a: u64, b: u64) acquires CoinA {
        if(a * b == 0) {
            return
        };

        let c = a - b;
        spec {
            // Implement the code here
        };

        let _d = get_balance(owner) + c;
    }

    #[test]
    fun testing() {
        add(1,2);
    }
}