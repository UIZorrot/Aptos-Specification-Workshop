In this section, we will setting up the env of prover, and use a simple move project to test if we have successfully setup the env.
We will learn:

* [How to install Aptos move cli and using the Move Prover](#how-to-install-aptos-move-cli-and-using-the-move-prover)
    + [Install Aptos CLI](#install-aptos-cli)
        - [Install On Mac](#install-on-mac)
        - [Install On Windows](#install-on-windows)
        - [Install On Linux](#install-on-linux)
    + [Install Dependencies Of MVP](#install-dependencies-of-mvp)
* [The structure of a .spec file](#the-structure-of-a-spec-file)
* [The basic pragma (aborts_partial, aborts_strict)](#the-basic-pragma-aborts_partial-aborts_strict)
* [The basic assertion (aborts_if)](#the-basic-assertion-aborts_if)

***

# How to install Aptos move cli and using the Move Prover

This section will show how to set up the env of prover. The Move Prover (MVP) is integrated in the Aptos CLI, a command line tool for developing, debugging, deploying and operating on the Aptos Network. So what we need to do is to include the installation of the [Aptos CLI][install_aptos_cli] and the [dependencies][install_dependencies] for the MVP.

## Install Aptos CLI

Four installation methods are provided; please choose the preferred one.

### Install On Mac

For Mac, the easiest way to install the Aptos CLI is with the package manager brew.

1. Ensure you have [brew](https://brew.sh/) installed.
2. Execute the following commands to install client.
    ```
    brew update
    brew install aptos
    ```
3. Check if client is installed.
    ```
    aptos help
    ```

### Install On Windows

For Windows, the easiest way to install the Aptos CLI tool is via Python script.

1. Ensure you have [python 3.6+](https://www.python.org/) installed.
2. Run the install script in PowerShell.
    ```
    iwr "https://aptos.dev/scripts/install_cli.py" -useb | Select-Object -ExpandProperty Content | python3
    ```
3. Update your PATH with the command looks something like the following one.
    ```
    setx PATH "%PATH%;C:\Users\<your_account_name>\.aptoscli\bin"
    ```
4. Check if client is installed.
    ```
    aptos help
    ```

### Install On Linux

For Linux, the easiest way to install the Aptos CLI tool is via Python script.

1. Ensure you have [python 3.6+](https://www.python.org/) installed.
2. Run the install script in your terminal.
    ```
    curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
    ```
    Or use the equivalent wget command:
    ```
    wget -qO- "https://aptos.dev/scripts/install_cli.py" | python3
    ```
3. Update your PATH with the command looks something like the following one.
    ```
    echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    ```
4. Check if client is installed.
    ```
    aptos help
    ```

### Install Specific Versions(Advanced)

If you need a specific version of the Aptos CLI, you can build it directly from the Aptos source code.

1. Follow the steps to build Aptos from source [here](https://aptos.dev/guides/building-from-source/)
2. Ensure you have [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html#install-rust-and-cargo) installed.
3. Build the CLI tool:.
    ```
    cargo build --package aptos --profile cli.
    ```
    The binary will be available at `target/cli/aptos` or `target\cli\aptos.exe`.
4. (Optional) Move this executable to a place in your PATH.
5. Check if client is installed.
    ```
    # for Linux/macOS
    target/cli/aptos help
    # for Windows
    target/cli/aptos.exe help
    ```
    Or 
    ```
    aptos help
    ```

## Install Dependencies Of MVP

If you want to use the Move Prover, install the Move Prover dependencies after installing the CLI binary.

1. Clone the Aptos repository.
    ```
    git clone https://github.com/aptos-labs/aptos-core.git
    ```
2. Install dependencies.

    For Linux/macOS
    ```
    cd aptos-core/
    ./scripts/dev_setup.sh -yp
    source ~/.profile
    ```
    For Windows
    ```
    PowerShell -ExecutionPolicy Bypass -File ./scripts/windows_dev_setup.ps1 -y
    ```
    > Note: Execute the Windows' command as an administrator!
3. You can now run the Move Prover to prove an [example](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/hello_prover).
    ```
    aptos move prove --package-dir aptos-move/move-examples/hello_prover/
    ```

# The structure of a .spec file

A `.spec` file is a contract verification file. It serves as one of the inputs for the prover and is usually sent to the prover along with the source code. This file contains various `spec` blocks, such as `spec module`, `spec fun`, etc., representing formal descriptions of the contract's behavior and higher-level properties.

> Note: `spec` blocks also can appear in source code, just like the above [example](#the-structure-of-a-spec-file).

Typically, the structure of a `.spec` file is as follows:

```Move
spec module_owner::module_name {
    spec module {
        // global behavior and higher-level properties
    }

    spec function_name {
        // local behavior and higher-level properties
    }

    spec fun helper_func {
        // helper functions that aid in verifying the contract
    }

    spec shema SchemaName {
        // schemas
    }
}
```


# The basic pragma (aborts_partial, aborts_strict)


# The basic assertion (aborts_if)

[install_aptos_cli]: https://aptos.dev/tools/aptos-cli/install-cli/
[install_dependencies]: https://aptos.dev/tools/aptos-cli/install-cli/install-move-prover