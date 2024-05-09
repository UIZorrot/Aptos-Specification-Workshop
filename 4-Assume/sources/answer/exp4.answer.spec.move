spec section4::exp4_answer {
    spec module {
        pragma verify = true;

        global ghost_length: u64;
        global ghost_height: u64;

        global ghost_area_0: u64;
        global ghost_area_1: u64;

        global ghost_sqrt: u64;
    }

    spec area {
        ensures result == ghost_length * ghost_height / 2;
    }

    spec bigger_triangle {
        ensures if (ghost_area_0 > ghost_area_1) {
            result_1 == 1 && result_2 == ghost_area_0
        } else {
            result_1 == 2 && result_2 == ghost_area_1
        };
    }

    spec assume_test {
        // requires x > y;
    }

    spec perimeter {
        pragma verify = true;
        pragma opaque;
        pragma aborts_if_is_strict;

        let length = triangle.length;
        let heigth = triangle.heigth;

        aborts_if [concrete] length * length + heigth * heigth > MAX_U64;
        aborts_if [abstract] false;

        ensures [concrete] result == length + heigth + ghost_sqrt;
        ensures [abstract] result == spec_perimeter(triangle);
    }

    spec fun spec_perimeter(triangle: Triangle): u64;

}