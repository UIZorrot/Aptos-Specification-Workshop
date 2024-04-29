spec section5::exp5 {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec pre_conditions {
        requires len(global<ColorSet>(owner).color_set) == len(new_color_set);
        aborts_if !exists<ColorSet>(owner);
    }
}