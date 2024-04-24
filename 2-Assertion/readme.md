In this section, we will learn about the **assertion-related** functions. You will learn several **assertion methods in MSL** which are used to write specifications.

***

- [Assertions In `.move` Files](#assertions-in-the-move-files)
    - [Assert with `assert`](#assert-with-assert)
- [Assertions In `.spec` Files](#assertions-in-the-spec-files)
    - [Assert with `aborts_if`](#assert-with-aborts_if)
    - [Assert with conditional `aborts_if`](#assert-with-conditional-aborts_if)
    - [Assert with `aborts_with`](#assert-with-aborts_with)
- [Assertions Encountering Global State](#assertions-encountering-global-state)
- [Exercise](#exercise)

***

# Assertions In `.move` Files

In MSL, there are two main types of ways to write specifications, in the source code(`.move` file) and in the `.spec` file. In this subsection, the method of assertion in the `.move` file will be described.

## Assert with `assert`

An `assert` statement within a spec block defines a condition that **must be true** when execution reaches that point; if not, an error will be reported.

The `assert` statement will always appear in the `spec{}` block, which is formatted like this:

```Move
spec {
    assert boolean_expression;
};
```

Let's go through an example to give us a clearer picture of its usage. There is an `assert` statement which is specification of line 7 in function `add` of `sources/exp2.move`. We all know that the variable `c` must be equal to `a+b` by the time the programme has finished line 7. So we assert `c = a + b` on line 9 to make sure that the value of the variable is correct when the programme gets to this point and that there are no surprises.

# Assertions In .`spec` Files

There are several methods of assertion in the .spec file.

## Assert with `aborts_if`

We are no strangers to the `aborts_if` assertion method, which has been mentioned in Section 1. However, it still deserves to be reintroduced, which would be more comprehensive.

The `aborts_if` assertion can only appear in a separate **function** in the .`spec` file. It needs to be used with a **boolean expression** to assert potential abort scenarios in this function. An error will be reported if the boolean expression is not satisfied. Its format is as follows:

```Move
spec function_name {
    aborts_if boolean_expression;
}
```

In the `add` function of `sources/exp2.move`, it is evident that: 1. `a * b` should always be greater than 0, otherwise it would violate the assertion on line 5; 2. `a + b` should always be less than `MAX_U64` to avoid causing an integer overflow. As for each point, we use `aborts_if` statements in `sources/exp2.spec.move` to exclude unexpected scenario.

## Assert with conditional `aborts_if`

The condition `aborts_if` statement is an advancement of `aborts_if` statement which means that the `aborts_if` condition can be augmented with an error code. In other words, if the function does not abort at the **given code**, then an error will also be reported.
Its format is as follows:

```Move
spec function_name {
    aborts_if boolean_expression with error_code;
}
```

> Note: Prover provides a special constant `EXECUTION_FAILURE` to specify VM failures(division by zero, overflow, etc.).

The `aborts_if` statements in the `add` function of `sources/exp2.move` could be improved with conditional `aborts_if` statements. For the assertion on line 5, just use the error code it provides. For the addition on line 7, the constant `EXECUTION_FAILURE` can be used. The updated code is in the form of comments within the function `add` of `sources/exp2.spec.move`.

## Assert with `aborts_with`

The `aborts_with` condition allows specifying with which codes a function can abort, independent under which condition. It is similar to a `throws` clause in languages like Java. The `aborts_with` assertion can only appear in a separate **function** in the .`spec` file. Its format is similar to conditional `aborts_if`, but without boolean expression:

```Move
spec function_name {
    aborts_with error_code;
}
```

`aborts_with` can be seen as an alternative or supplement to `aborts_if`. This means that the specification written with `aborts_if` can be replaced by `aborts_with`, and `aborts_with` can also specify any additional codes, in addition to the ones given in `aborts_if`. Additionally, `aborts_with` can be used alongside `aborts_if` to specify the same abort condition. 

The specification for the function `add` can be indicated with `aborts_with 666;`, which represents the the assertion on line 5 that provides the error code `666`, and `aborts_with EXECUTION_FAILURE;`, which represents the VM failure on line 7.

# Assertions Encountering Global State

Smart contracts in the Move language often involve operations that access **data on the chain** or **global state**. When encountering operations that access data on the chain or global state, it is necessary to use the **built-in functions** provided by MSL for verification.

The common operations for accessing the global state are as follows:

| Operation | Description | Aborts? |
| :--- | :--- | :--- |
| `move_to<T>(&signer,T)` | Publish `T` under `signer.address` | If `signer.address` already holds a `T` |
| `move_from<T>(address): T` | Remove `T` from `address` and return it | If `address` does not hold a `T` |
| `borrow_global_mut<T>(address): &mut T` | Return a mutable reference to the `T` stored under `address` | If `address` does not hold a `T` |
| `borrow_global<T>(address): &T` | Return an immutable reference to the `T` stored under `address` | If `address` does not hold a `T` |
| `exists<T>(address): bool` | Return true if a `T` is stored under `address` | Never |

We write specifications based on `Description` and `Aborts?`. Taking the first operation as an example. It will abort if `signer.address` already holds a `T`. Therefore, we use the built-in function `exists` which is mentioned in Section 1 to write specifications, such as `aborts_if exists <T>(address);`.

We provide an example in the function `get_balance` of `sources/exp2.move`. This example uses the `borrow_global` operation, and its specification code, which can be found in `sources/exp2.spec.move`, also relies on the function `exists`.

# Exercise

Now you have learned various assertion methods. There are exercises left in the function `get_balance_1` of `sources/exp2.move` and `sources/exp2.spec.move`. Give it a try! The answers can be found in the `./sources/answer` directory.
