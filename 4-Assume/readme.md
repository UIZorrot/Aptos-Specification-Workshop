In this section, we will learn about **assumption-related** techniques in MSL. Specifically, we will learn about **ghost variables**, the **`assume` statement**, and the **`opaque` function**.

***

* [Ghost Variable](#ghost-variable)
* [`assume` Statement](#assume-statement)
* [`oqaupe` Function](#oqaupe-function)
* [Exercise](#exercise)

***

# Ghost Variable

In the verification community, there is a special type of variable called **ghost variable**. Its formal name is **spec variable**, but **ghost variable** is more commonly used. They are used in spec blocks and represent information derived from the global state of resources. Loosely speaking, you can think of them as **copies** of the actual variables in the function. Its use is divided into three steps:

1. define ghost variables
    ```Move
    spec module {
        global ghost_var_name: T0; // (a)
        global ghost_var_name<T>: num; // (b)
    }
    ```

    There are two ways to define variables, both of which must be defined in the `spec module`. For (a), the variable type(`T0`) must be explicitly specified to match the actual variable type in use. For (b), it is a **generic** type designated as the built-in type `num`, which represents all **unsigned integers**. In usage, (b) allows `T` to be automatically inferred as the matching variable type, such as `u32`, `u64`, etc.

    In `exp4.spec.move` we define two `u64` ghost variables, which represent the length and height of the triangle respectively. In fact, the purpose of these two ghost variables is to capture the length and height ​​in the actual function.

2. assign ghost variable

    ```Move
    spec {
        update ghost_var_name_0 = var_0;
        assume ghost_var_name_1 == var_1;
    }
    ```

    Here we use two methods to show how to capture the actual variable value:
    * `update` keyword: The `update` here is like the `let` in Move. It assigns the value of `var_0` to `ghost_var_name_0`.
    * `assume` keyword: The semantics of `assume` here is to assume that the value of `ghost_var_name_1` equals `var_1`, which essentially has the effect of assignment. This is a more interesting and common usage and is one of the reasons why we placed this subsection in Section 4.

    In the function `area` of `exp4.move`, we have used both methods to obtain the length and height of the triangle. Now, `ghost_length` and `ghost_height` store the values of `length` and `height` when the function reaches the spec block.

3. use ghost variables

    ```Move
    spec {
        // Use here
    }

    spec function_name {
        // Use here
    }
    ```

    After assigning a value to a ghost variable, it can be used within the function or in the function's spec. Since there are many ways to use them, we will not enumerate them all. In the function `area` and its `spec area`, we provide examples.

In the function `bigger_triangle`, we have left an ***exercise*** for you to become more familiar with ghost variables. You need to complete the specification for its `ensures` statement. In the `ensures` statement, try to use ghost variables.

# `assume` Statement

We are not unfamiliar with `assume`, as it has already been introduced in the previous subsection. However, the powerful functionality of `assume` goes beyond that.

The `assume` condition which are allowed in `spec` blocks creates a fictitious environment which satisfies its condition, which sounds like `requires`. But an `assume` statement blocks executions violating the condition in the statement. That means it may not throw an error even the `assume` statement is wrong, which makes it different from `requires` and more dangerous. And it need us to be more cautious when we use it.

> Note: When `assume` is used to assign a ghost variable, it is safe as it just captures the value or state rather than changing it.

Its usage is like:

```Move
spec {
    assume boolean_expression;
}
```

Let's briefly introduce its common application scenarios:

1. assign ghost variable: This scenario is introduced in previous subsection.
2. When the prover is unable to deduce the environment in which the function runs normally for some reason, the `assume` statement is needed to manually specify the conditions or the running environment of the function.
3. Reasonably limit the range of values ​​to prevent timeouts.
    > Note: The second and third points must be handled very carefully, and you must be very confident when using them. Otherwise, it is recommended to use the `requires` statement instead.

In the function `assume_test`, there is an assertion `assert z > 2 * y;`, which requires `x > y`. The current approach uses a `requires` statement to make this assertion pass. You can remove the `requires` statement and use an `assume` statement in the function to pass this assertion instead. This serves as an ***exercise***.

# `oqaupe` Function

The `opaque` function means that the function's spec is marked with `pragma opaque`. With the `pragma opaque`, a function is declared to be solely defined by its specification at caller sides. In contrast, if this pragma is not provided, then the function's implementation will be used as the basis to verify the caller. Its usage is like:

```Move
spec function_name {
    pragma opaque;

    aborts_if [concrete] boolean_expression;
    aborts_if [abstract] boolean_expression;

    ensures [concrete] boolean_expression;
    ensures [abstract] boolean_expression;
}
```

In the `abort_if` and `ensures` statements within the spec block, two types of tags appear: `[concrete]` and `[abstract]`. 

* `[concrete]`: A specification statement marked with `[concrete]` will be verified against the function's actual implementation. `[concrete]` statement is optional and should be used as appropriate.
* `[abstract]`: A specification statement marked with `[abstract]` will be considered the entirety of the function's content presented to the caller. It carries an **assumption**. `[abstract]` statement is required because the purpose of using `pragma opaque` is to hide the function's full implementation from external callers.
    > Note: Statements marked with `[abstract]` must be used carefully because they are prone to **contamination**. If the specification is incorrect, it will affect the caller's verification. ***The soundness of the abstraction is the responsibility of the specifier, and not verified by the prover.***

A statement marked with `[abstract]` is considered the entirety of the function's information, so it should be detailed enough to meet the verification requirements at the caller's end. To provide more and more efficient information, we can use **helper functions** which usually appears as function's abstract result. Its usage is like:

```Move
spec project_name::module_name {
    spec function_name {
        pragma opaque;

        ensures [abstract] result == helper_func_name(para_0, ...);
    }

    // (a)
    spec fun helper_func_name(
        para_0: T0, 
        para_1: T1, 
        ...,
    ): return_type;

    // (b)
    spec fun helper_func_name(
        para_0: T0, 
        para_1: T1, 
        ...,
    ): return_type {
        // function body
    }
}
```

The definition of a helper function is very similar to a Move function, with the difference being that a helper function is defined using the `spec fun` keyword and needs to be defined within the `spec module_name`. There are two ways to define it, as shown in (a) and (b). For (a), the definition is simpler; for (b), it has a function body and thus contains more information.

> Note: The usage of (a) is more common in regular function's spec, while the usage of (b) is more common in `opaque` function's spec. What's more, (b) could be **recursive**.

We have summarized the common application scenarios for `opaque` functions:

1. For unverifiable situations, such as the verification of native functions, we use opaque functions to abstract their capabilities. This approach has two benefits: **a. It can be verified by the prover. b. A helper function can be used to replace it, making it callable in MSL.**

2. In certain cases, such as functions involving complex calculations, the implementation details of the function **do not affect** the caller's verification, or we are not concerned about the implementation details of the function. However, to avoid timeouts and similar issues, we can make the function `opaque` and use a helper function to replace it to improve verification efficiency. 
    > Note: This approach should only be used in extreme cases; otherwise, using opaque functions indiscriminately will be considered irresponsible.

Here is a good [example][a_good_example] of `opaque` function:

```Move
// https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/math64.move

/// Return the value of n raised to power e
public fun pow(n: u64, e: u64): u64 {
    if (e == 0) {
        1
    } else {
        let p = 1;
        while (e > 1) {
            if (e % 2 == 1) {
                p = p * n;
            };
            e = e / 2;
            n = n * n;
        };
        p * n
    }
}
```

```Move
// https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/math64.spec.move

spec pow(n: u64, e: u64): u64 {
    pragma opaque;
    aborts_if [abstract] spec_pow(n, e) > MAX_U64;
    ensures [abstract] result == spec_pow(n, e);
}

spec fun spec_pow(n: u64, e: u64): u64 {
    if (e == 0) {
        1
    }
    else {
        n * spec_pow(n, e-1)
    }
}
```

The function `pow` calculates the value of `n` raised to the power of `e`. Since its verification is too complex, and possibly unverifiable, the function is set as an `opaque` function and replaced by the simpler function `spec_pow`, making it usable at caller sides. From the caller's perspective, the function `pow` will abort if the result exceeds `MAX_U64`, and the result is fully equivalent to `spec_pow`.

The function `perimeter` in `exp4.move` is provided as an ***exercise***. Requirements:  
* Use `aborts_if [concrete]` and `aborts_if [abstract]` statements in the `spec perimeter` to verify it itself.  
* From the caller's perspective, it needs to be abstracted as a function that **will not abort** and whose result is **equivalent to `spec_perimeter(triangle)`**.

# Exercise

There are several exercises left above. Give it a try! The answers can be found in the `./sources/answer` directory.

[a_good_example]: https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/math64.move


