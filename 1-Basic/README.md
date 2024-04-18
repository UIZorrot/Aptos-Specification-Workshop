In this section, we will learn some basic knowledge about the structure of the Move project and the .spec file structure, and try to use prover to verify a simple Move project.

***

* [The Structure of a Move Project](#the-structure-of-a-move-project)
* [The Structure of a .spec File](#the-structure-of-a-spec-file)
* [Verify Your First Move Project](#verify-your-first-move-project)
    * [The basic pragma (aborts_partial, aborts_strict)](#the-basic-pragma-aborts_partial-aborts_strict)
    * [The basic assertion (aborts_if)](#the-basic-assertion-aborts_if)

***

# The Structure of a Move Project

Typically, the structure of a move project with validation code looks like this:

```sh
move_project
      |-sources
           |-exp1.move
           |-exp1.spec.move
      |Move.toml
```

Your source code(*exp1.move*) and verification code(*exp1.spec.move*) are stored in the ***sources*** directory.

The prover’s verification work is executed under the `move-project/` directory. So you can switch to the directory where this document is located(`1-Basic/`), and execute the `aptos move prove` command to verify the Move project in this directory. 

After executing the `aptos move prove` command, you will encounter the following error. Don't worry about this, it's normal. In addition, congratulations on achieving two milestones: 1. Your installation was successful; 2. You now know how to verify a Move project.

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

A `.spec` file is a contract verification file. It serves as one of the inputs for the prover and is usually sent to the prover along with the source code. This file contains various `spec` blocks, such as `spec module`, `spec fun`, etc., representing formal descriptions of the contract's behavior and higher-level properties.

> Note: `spec` blocks also can appear in source code, just like the above [example](#the-structure-of-a-spec-file).

Typically, the structure of a `.spec` file is as follows:

```Move
spec module_owner::module_name {
    spec module {
        // global behavior and higher-level properties
    }

    spec struct_name {
        // struct properties
    }

    spec function_name {
        // local behavior and higher-level properties
    }

    spec fun helper_func {
        // helper functions that aid in verifying the contract
    }

    spec schema SchemaName {
        // schemas
    }
}
```

The prover verifies each module in the source code one by one. So the verification of a specific module under the module's owner account is done by the code in the `spec module_owner::module_name` block. In this block, to gain a deeper understanding of the structure of .spec files, the five types of spec blocks are further divided into three categories based on their functions:

* global verification

# Verify Your First Move Project

## The basic pragma (aborts_partial, aborts_strict)


## The basic assertion (aborts_if)

