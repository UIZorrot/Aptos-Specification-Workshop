In this section, we will learn about the **pre, post and global conditions** which make the specifications more complete and strict. Specifically, we will learn the usage of `requires`, `ensures` and `invariant` in MSL which represent pre, post and global conditions respectively.

***

* [Pre Condition(requires)](#pre-conditionrequires)
* [Post Condition(ensures)](#post-conditionensures)
* [Global Condition(invariant)](#global-conditioninvariant)
    * [global state of functions](#global-state-of-functions)
    * [global state of structs](#global-state-of-structs)
    * [global state of module](#global-state-of-module)
* [Exercise](#exercise)

***

# Pre Condition(requires)

Pre conditions refer to conditions that **must be met** before executing a function, which limit the environment in which the function executes. In MSL, Pre conditions are the `requires` statements. 

The `requires` statement postulates a pre condition for a function. If the function does not meet the conditions specified in the `requires` statement, it will throw an error. Its usage is like:

```Move
spec function_name {
    requires boolean_expression;
}
```

The `requires` statement, from certain perspectives, resembles `aborts_if`, but they are distinctly different. There are clear distinctions between them. `requires` has two major characteristics that `aborts_if` lacks, which we refer to as assumption and contamination.

* **assumption**: The `requires` statement expresses an assumption that certain conditions must be true before the function can be executed.
* **contamination**: If the `requires` statement is used inappropriately, it may cause incorrect changes to the environment or state. This can affect subsequent operations and functions.

Based on these characteristics, the use of `requires` needs to be very cautious. Consequently, its application scenarios are also greatly limited: 

1. When the prover is unable to deduce the environment in which the function runs normally for some reason, the `requires` statement is needed to manually specify the pre conditions or the running environment of the function. Otherwise, the prover will throw an error.
2. It is common for functions to contain extremely complex computations. However, during verification, the prover sometimes times out (the default verification time is 40 seconds). In such cases, it is necessary to appropriately limit the range of values to allow the prover to successfully complete within 40 seconds.
3. When the function called in the function has pre conditions, then the pre conditions also need to be added to the current function.

> Note: The above three points are common applications, but this does not mean that `requires` can only be used in these scenarios.

To gain a deeper understanding of `requires`, we demonstrate the application of the first two scenarios in the function `get_original_price` of `sources/exp3.move`. 

As we all know, a discount cannot be 0, as no merchant would set a product's discount to 0. However, the prover is not aware of this fact and thus throws an error during the verification process. The best solution for this impossible error is to make the prover recognize that the discount will not be 0 by using `requires promotion.discount > 0;`. This is an example of the first application scenario.

Timeouts may occur during computation. Although a timeout is not likely in the `get_original_price` example, let's assume the function involves complex calculations that do cause a timeout. To reduce the verification time, we could limit the range of the `discount` variable from `(0, MAX_U64]` to `(0, 100]`, which would significantly shorten the verification time. Note that this setting is reasonable, as this is the normal range for discounts; anything over 100 would constitute a price increase, not a promotion. This is an example of the second application scenario.

As an ***exercise***, you can experience the third scenario in the function `get_discount` of `sources/exp3.move`.

# Post Condition(ensures)

Post conditions refer to the conditions that **must be met** after a function is executed, which specifies the execution result of the function. In MSL, Post conditions are the `ensures` statements. 

The `ensures` condition postulates a post condition for a function which must be satisfied when the function terminates successfully (i.e. does not abort). The prover will verify each `ensures` to this end. Its usage is like:

```Move
spec function_name {
    ensures boolean_expression;
}
```

For cases with multiple possible execution outcomes, there are several ways to write this.  

```Move
spec function_name {
    // first method
    ensures result_exp1 || result_exp2;

    // second method
    ensures cond1 ==> result_exp1;
    ensures cond2 ==> result_exp2;

    // third method
    ensures if(cond1) {
        result_exp1
    } else {
        result_exp2
    };
}
```

The first method uses `||` to connect all outcomes, which is not recommended as the outcomes are not intuitive. The second method uses `==>` to **detail** the outcomes. Simply put, under the scenario of `cond1`, the function will yield the outcome of `result_exp1`. Simply put, under the scenario of `cond2`, the function will yield the outcome of `result_exp2`. The third method is more intuitive and highly recommended. It uses the syntax structure of `if`, but it requires that `cond1` and `cond2` be mutually exclusive.

The `ensures` statement has two common application scenarios:

* **For return value**: When a function has a return value, it is necessary to verify whether the return value matches the expected value. Based on the number of return values, we categorize them into two types:

    * **Single return value**: In the MSL, the keyword `result` is used to represent the unique return value. We provide two examples. In the functions `get_original_price` and `get_cheaper_price`, we respectively verify cases with one return result and multiple possible return results. For the function `get_cheaper_price`, we use three different methods of verification to address the multiple possible outcomes.

    * **Multiple return values**: In MSL, `result_n` (where n >= 1) is used to represent the corresponding return values. For example, `result_1` represents the first return value of the function, `result_2` represents the second return value, and so on. You can use the function `get_discount` as a simple ***exercise***.

* **For global state's changes**: When a function modifies the global state, we must be cautious as this will result in changes to the data on the blockchain. We need to use built-in functions like `exists`, `global`, or `old`, which were introduced in Section 1, to access the global state in MSL. Here, we also provide an ***exercise***, attempting to write the specification for the function `change_info`.

> Note: you can directly use `old` and `global` in `ensures` statements, which represent pre and post state respectively. Otherwise, you can use `let var = xxx;` and `let post post_var = xxx;` first, then `var` and `post_var` can be used in `ensures` statements which represent pre and post state respectively.

# Global Condition(invariant)

Global conditions refer to conditions that are maintained **before, during and after** program execution. In MSL, Global conditions are the `invariant` statements. Its usage is like:

```Move
spec module {
    invariant boolean_expression_1;
}

spec struct_name {
    invariant boolean_expression_2;
}

spec function_name {
    invariant boolean_expression_3;
}
```

As demonstrated in the template above, `invariant` conditions can be applied to verify the **global state of functions, structs, and module**.

## global state of functions

The `invariant` condition on a function is simply a shortcut for a `requires` and `ensures` with the same predicate. Taking the function `get_original_price` as an example, it clearly satisfies both:

```Move
spec get_original_price {
    requires promotion.discount > 0;
    ensures promotion.discount > 0;
}
```

Thus, we can use the `invariant promotion.discount > 0;` to replace both the pre and post conditions, indicating that this condition is always satisfied throughout the function.

## global state of structs

All calls to functions containing global conditions will be checked to ensure that the global conditions within the struct are met. This means that the `invariant` conditions in the struct must be satisfied throughout the **lifecycle of the struct**.

For the **Promotion** struct, since its **discount** field must be greater than 0, an **invariant** statement can be written within its body to verify this property. That would be `invariant discount > 0;`.

## global state of module

An `invariant` statement written in the `spec module` represents a global property that needs to be satisfied throughout the **entire module**. Its scope of influence encompasses the whole module.

Continuing with the example of the **discount** field, we require that for all bosses of malls, the discount on their products must be greater than 0. This utilizes the `forall` quantifiers, which were introduced in Section 1. You can use this simple example as an ***exercise***.

# Exercise

Now you have learned pre, post and global conditions. There are several exercises left above. Give it a try! The answers can be found in the `./sources/answer` directory.