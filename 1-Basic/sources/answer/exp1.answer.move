spec section1::exp1
{
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec add(a: u64, b: u64)
    {
        aborts_if a + b > MAX_U64;
    }

}