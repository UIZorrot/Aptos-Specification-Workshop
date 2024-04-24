spec section2::exp2 {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec add {
        aborts_if a * b == 0;
        aborts_if a + b > MAX_U64;
        
        aborts_with 666, EXECUTION_FAILURE;
    }

    spec get_balance {
        aborts_if !exists<CoinA>(owner); // Or aborts_if !exists<CoinA>(owner) with 999;

        aborts_with 999;
    }

    spec get_balance_1 {
        pragma verify = true;

        aborts_if a * b > MAX_U64;
        aborts_if a * b > 0 && a < b;
        aborts_if a * b > 0 && !exists<CoinA>(owner);
        aborts_if a * b > 0 && global<CoinA>(owner).balance + a - b > MAX_U64;

        aborts_with EXECUTION_FAILURE, 999;
    }
}