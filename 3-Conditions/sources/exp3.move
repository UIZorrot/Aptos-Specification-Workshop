module section3::exp3 {

    struct Mall has key {
        coca_cola: Promotion,
    }

    struct Promotion has copy, store, drop {
        current_price: u64,
        discount: u64,
    }

    fun get_original_price(promotion: &Promotion): u64 {
        let current_price = promotion.current_price;
        let discount = promotion.discount;
        current_price * 100 / discount
    }

    fun get_cheaper_price(promotion: &Promotion, another_price: u64): u64 {
        let current_price = promotion.current_price;

        if(current_price > another_price) {
            another_price
        } else {
            current_price
        }
    }

    fun get_discount(promotion: &Promotion): (u64, u64) {
        let discount = promotion.current_price * 100 / get_original_price(promotion);
        (discount, 100)
    }

    // If tag is true, change current_price field and return the result, 
    // otherwise change discount field and return the result.
    fun change_info(boss: address, tag: bool, new_info: Promotion): u64 acquires Mall {
        let coca_cola = &mut borrow_global_mut<Mall>(boss).coca_cola;

        if(tag == true) {
            coca_cola.current_price = new_info.current_price;
            coca_cola.current_price
        } else {
            coca_cola.discount = new_info.discount;
            coca_cola.discount
        }
    }

}