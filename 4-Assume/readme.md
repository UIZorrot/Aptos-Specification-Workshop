
介绍和assume有关的技术

ghost var
ghost var怎么定义
ghost var怎么使用

oqaupe
oqaupe怎么定义
oqaupe怎么使用
怎么定义helper function
oqaupe的污染性

assume
assume怎么用
assume慎用（导致inconsistency）



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
