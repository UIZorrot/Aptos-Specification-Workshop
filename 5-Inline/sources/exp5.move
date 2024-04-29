module section5::exp5 {
    use std::vector;

    struct ColorSet has key {
        color_set: vector<Color>,
    }

    struct Color has copy, store, drop {
        red: u64,
        green: u64,
        blue: u64,
    }

    fun pre_conditions(owner: address, new_color_set: vector<Color>) acquires ColorSet {
        assert!(exists<ColorSet>(owner), 0);

        let color_set = borrow_global_mut<ColorSet>(owner);
        let length = vector::length<Color>(&new_color_set);
        let i = 0;

        while({
            spec {
                invariant i <= length;
                invariant forall j in 0..i: color_set.color_set[j].red == new_color_set[j].red;
                invariant length == len(color_set.color_set);
            };

            i < length
        }) {
            vector::borrow_mut(&mut color_set.color_set, i).red = vector::borrow(&new_color_set, i).red;
            i = i + 1;
        }
    }

}