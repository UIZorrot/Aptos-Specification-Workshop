In this section, we will learn some **basic knowledge** about the structure of the Move project, the .spec file structure and basic skills, and try to use prover to verify a simple Move project.

***

* [The Structure of a Move Project](#the-structure-of-a-move-project)
* [The Structure of a .spec File](#the-structure-of-a-spec-file)
* [Basic Skills](#basic-skills)
    * [The basic pragma](#the-basic-pragma)
    * [The basic assertion ](#the-basic-assertion)

***

# The Structure of a Move Project

Typically, the structure of a move project with validation specifications looks like this:

```sh
move_project
      |-sources
           |-exp1.move
           |-exp1.spec.move
      |Move.toml
```

Your source code(`exp1.move`) and specifications(`exp1.spec.move`) are stored in the ***sources*** directory.

The prover’s verification work is executed under the `move-project/` directory. So you can switch to the directory where this document is located(`1-Basic/`), and execute the `aptos move prove` command to verify the Move project in this directory. 

After executing the `aptos move prove` command, you will encounter the following error. Don't worry about this, it's normal. In addition, congratulations on achieving two milestones: **1. Your installation was successful**; **2. You now know where and how to verify a Move project**.

```
yun@MateBook-Pro 1-Basic % aptos move prove
[INFO] checking specifications
[INFO] rewriting specifications
[INFO] preparing module 0xe5f360395b3e7d6e93d4e47cfe177fbe03af4f71e7b97fb3f6c57e5ff0876875::exp1
[INFO] transforming bytecode
[INFO] generating verification conditions
[INFO] 1 verification conditions
[INFO] running solver
[INFO] 0.147s build, 0.008s trafo, 0.007s gen, 0.942s verify, total 1.104s
error: abort not covered by any of the `aborts_if` clauses
   ┌─ Aptos-Specification-Workshop/1-Basic/sources/exp1.spec.move:8:5
   │  
 8 │ ╭     spec add( a: u64, b: u64)
 9 │ │     {
10 │ │         // Implement the code here
11 │ │     }
   │ ╰─────^
   │  
   ┌─ Aptos-Specification-Workshop/1-Basic/sources/exp1.move:6:18
   │
 6 │         let c= a + b;
   │                  - abort happened here with execution failure
   │
   =     at Aptos-Specification-Workshop/1-Basic/sources/exp1.move:4: add
   =         a = 1
   =         b = 18446744073709551615
   =     at Aptos-Specification-Workshop/1-Basic/sources/exp1.move:6: add
   =         ABORTED

{
  "Error": "Move Prover failed: exiting with verification errors"
}

```

# The Structure of a .spec File

To solve the above vulnerability, we need to analyze the causes of the vulnerability. But before the analysis, we need to understand the structure of the `.spec` file first.

A `.spec` file is a verification file. It serves as one of the inputs for the prover and is usually sent to the prover along with the source code. This file, which is written in the ***Move Specification Language***(MSL), contains various `spec` blocks, such as `spec module`, `spec fun`, etc. These blocks represent formal descriptions of the contract's behavior and high-level properties.

> Note: `spec` blocks also can appear in source code, just like the special example [here](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/hello_prover).

Typically, the structure of a `.spec` file is as follows:

```Move
spec project_name::module_name {
    spec module {
        // global behavior and high-level properties
    }

    spec struct_name {
        // struct properties
    }

    spec function_name {
        // local behavior and high-level properties
    }

    spec fun helper_func(paras: T0): T1 {
        // helper function
    }

    spec schema SchemaName {
        // schema
    }
}
```

The prover verifies each module in the sources code one by one. So the verification of a specific module is done by the specification code in the `spec project_name::module_name` block. In this block, to gain a deeper understanding of the structure of .spec files, the five types of spec blocks are further divided into three categories based on their features:

* **global specification**
    + `spec module`: This block describes the global behavior and high-level properties, and its specification usually affects all functions in the module (except for the specified excluded functions).
    + `spec struct_name`: This block describes the behavior and high-level properties of a specified struct `struct_name`, and its scope of influence usually includes all functions involving this struct.
* **local specification**
    - `spec function_name`: This block contains the description of the behavior and high-level properties of the specified function `function_name`, and its impact only involves itself.
* **helper specification**
    * `spec fun helper_func`: This is the block of the helper function, which often comes with parameters and return values and can be called by other spec blocks.
    * `spec schema SchemaName`: Spec block declaring a schema. Schemas are a means for structuring specifications by grouping properties together. Semantically, they are just syntactic sugar which expand to conditions on functions, structs, or modules.

Now we can find that there is only one `add` function in `exp1.move`, and its verification is defined in the `spec add` block. The problem is that the `spec add` block is currently empty, and the potential **integer overflow** problem in the function `add` is not defined here.

# Basic Skills

We have identified the problem, but at the same time, professional skills are needed to fix the vulnerability. Therefore, in this subsection, we will learn the two most basic skills, which are **pragma** and **assertion**.

## The basic pragma

Pragmas are a generic mechanism to influence interpretation of specifications. A pragma in a `spec module` block sets a value which applies to all other spec blocks in the module. A pragma in a `spec function_name` or spec `struct_name` block can override this value for the function or struct.

* `pragma aborts_if_is_strict [= true];`: `aborts_if_is_strict`(the default is false) can find all possible abort situations under the current scope. 
    > Note: This is why prover reports the above error.
* `pragma aborts_if_is_partial [= true];`: `aborts_if_is_partial`(the default is false) allows the prover to only check the currently existing specification. Although there are still possible abort situations, the prover still ignores them.
    > Note: Spec blocks using this pragma cannot be considered strict verification because it ignores possible vulnerabilities. It needs to be used with great caution, usually when you are very confident about the source code.

    > Note: If the pragma in the spec module is replaced with partial, prover will pass the verification. But this ignores the problem of integer overflow, which is irresponsible and dangerous.

## The basic assertion

Assertions help identify situations in the source code that will cause an abort. The basic assertion is `aborts_if` condition.

The `aborts_if` condition is a spec block member which can appear only in a **function** context. It specifies conditions under which the function aborts. For example, `aborts_if x < 0` would mean that the code will abort if the variable x is less than zero. We need to manually specify all possible exceptional cases for a function. The prover checks whether the `aborts_if` condition is correct; if it is, the prover will pass, otherwise, it will throw an error and provide a corresponding counterexample.

By now, you should be very familiar with the reasons for exceptions in the `exp1.spec.move` file and have learned how to use the `abort_if` condition at the correct places to complete the writing of specification code. Just have a try! The answer is available in the `./sources/answer/` directory.