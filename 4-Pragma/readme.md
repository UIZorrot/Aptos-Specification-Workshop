
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

* **helper specification**
    * `spec fun helper_func`: This is the block of the helper function, which often comes with parameters and return values and can be called by other spec blocks.
    * `spec schema SchemaName`: Spec block declaring a schema. Schemas are a means for structuring specifications by grouping properties together. Semantically, they are just syntactic sugar which expand to conditions on functions, structs, or modules.