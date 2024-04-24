spec section2::exp2 {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec add {
        aborts_if a * b == 0; // Or aborts_if a * b == 0 with 666;
        aborts_if a + b > MAX_U64; // Or aborts_if a + b > MAX_U64 with EXECUTION_FAILURE;

        aborts_with 666, EXECUTION_FAILURE;
    }

    spec get_balance {
        aborts_if !exists<CoinA>(owner); // Or aborts_if !exists<CoinA>(owner) with 999;

        aborts_with 999;
    }

    spec get_balance_1 {
        pragma verify = false;

        // Implement the code here
        // Before proving, make sure verify pragma has been converted to true.
    }
}