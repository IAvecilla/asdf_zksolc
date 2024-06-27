# asdf_zksolc

[zksolc](https://github.com/matter-labs/era-compiler-solidity) compiler plugin for asdf version manager.

## Pre-requisites

This plugin does NOT install the solidity compiler `solc` that `zksolc` needs to work correctly.

See how to install it [here](https://docs.soliditylang.org/en/latest/installing-solidity.html) or add the correct [plugin](https://github.com/diegodorado/asdf-solidity) and follow the instructions to installing it.

## Install

Run the following command to add the plugin:

```bash
asdf plugin add zksolc https://github.com/IAvecilla/asdf_zksolc.git
```

To check that the plugin was succesfully added, you can list all the compatible versions of the zksolc tool:

```bash
asdf list-all zksolc
```

To install a new version and use it across different projects

```bash
# This will install the latest released version
asdf install zksolc latest

# This sets that version as default for all projects
asdf global zksolc latest
```

To test that everyone is workin as expected check the installed version

```bash
# Should output the last version of the compiler
zksolc --version
```
