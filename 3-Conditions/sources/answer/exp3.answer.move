spec section3::exp3 {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;

        invariant forall addr: address where exists<Mall>(addr): 
            global<Mall>(addr).coca_cola.discount > 0;
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
        ensures if(current_price > another_price) {
            result == another_price
        } else {
            result == current_price
        };
    }

    spec get_discount {
        pragma verify = true;

        // the third scenario of "requires" statement
        requires promotion.discount > 0;
        requires promotion.discount <= 100;

        aborts_if promotion.current_price == 0;
        aborts_if promotion.current_price * 100 > MAX_U64;

        // "ensures result_1 == promotion.discount" cannot pass due to loss of precision.
        ensures result_1 == promotion.current_price * 100 / (promotion.current_price * 100 / promotion.discount);
        ensures result_2 == 100;
    }

    spec change_info {
        pragma verify = true;

        let post post_coca_cola = global<Mall>(boss).coca_cola;

        aborts_if !exists<Mall>(boss);

        ensures if(tag == true) {
            post_coca_cola.current_price == new_info.current_price
                && result == new_info.current_price
        } else {
            post_coca_cola.discount == new_info.discount
                && result == new_info.discount
        };
    }
}