spec section3::exp3 {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;

        // Implement the code here
    }

    spec Promotion {
        invariant discount > 0;
    }

    spec get_original_price {
        invariant promotion.discount > 0;

        requires promotion.discount > 0;
        requires promotion.discount <= 100;

        aborts_if promotion.current_price * 100 > MAX_U64;

        ensures result == promotion.current_price * 100 / promotion.discount;
    }

    spec get_cheaper_price {
        let current_price = promotion.current_price;

        // first method
        ensures result == current_price || result == another_price;

        // second method
        ensures current_price > another_price ==> result == another_price;
        ensures current_price <= another_price ==> result == current_price;

        // third method
        // Implement the code here
    }

    spec get_discount {
        pragma verify = false;

        // Implement the code here
        // Before proving, make sure verify pragma has been converted to true.
    }

    spec change_info {
        pragma verify = false;

        // Implement the code here
        // Before proving, make sure verify pragma has been converted to true.
    }
}
