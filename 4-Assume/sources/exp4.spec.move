spec section4::exp4 {
    spec module {
        pragma verify = true;

        global ghost_length: u64;
        global ghost_height: u64;

        // Implement the code here
    }

    spec area {
        ensures result == ghost_length * ghost_height / 2;
    }

    spec bigger_triangle {
        // Implement the code here
    }

    spec assume_test {
        requires x > y;
    }

    spec perimeter {
        pragma verify = false;
        pragma opaque;
        pragma aborts_if_is_strict;

        // Implement the code here
        // Before proving, make sure verify pragma has been converted to true.
    }

    // helper function
    // Implement the code here

}