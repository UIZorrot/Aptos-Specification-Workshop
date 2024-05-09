module section4::exp4 {
    use aptos_std::math64::sqrt;

    struct Triangle has copy, store, drop {
        length: u64,
        heigth: u64,
    }

    fun area(triangle: Triangle): u64 {
        let length = triangle.length;
        let heigth = triangle.heigth;
        spec {
            update ghost_length = length;
            assume ghost_height == heigth;
        };

        let area = length * heigth / 2;
        spec {
            assert area == ghost_length * ghost_height / 2;
        };

        area
    }

    fun bigger_triangle(triangle_0: Triangle, triangle_1: Triangle): (u64, u64) {
        let area_0 = area(triangle_0);
        let area_1 = area(triangle_1);
        spec {
            // Implement the code here
        };

        if (area_0 > area_1) {
            (1, area_0)
        } else {
            (2, area_1)
        }
    }

    fun assume_test(x: u64, y: u64) {
        let z: u64;
        spec {
            // Implement the code here
        };

        z = x + y;
        spec {
            assert z > 2 * y;
        }
    }

    fun perimeter(triangle: Triangle): u64 {
        let length = triangle.length;
        let heigth = triangle.heigth;

        let hypotenuse = sqrt(length * length + heigth * heigth);
        spec {
            // Implement the code here
        };

        length + heigth + hypotenuse
    }
}

