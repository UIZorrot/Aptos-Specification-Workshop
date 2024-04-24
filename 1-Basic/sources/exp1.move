module section1::exp1 {
    use std::debug::print;

    fun add(a: u64, b: u64) {
        let c = a + b;
        print(&c);
    }

    #[test]
    fun testing() {
        add(1,2);
    }
}