<div align="center">

# asdf-opencode [![Build](https://github.com/petershen0307/asdf-opencode/actions/workflows/build.yml/badge.svg)](https://github.com/petershen0307/asdf-opencode/actions/workflows/build.yml) [![Lint](https://github.com/petershen0307/asdf-opencode/actions/workflows/lint.yml/badge.svg)](https://github.com/petershen0307/asdf-opencode/actions/workflows/lint.yml)

[opencode](https://opencode.ai/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add opencode
# or
asdf plugin add opencode https://github.com/petershen0307/asdf-opencode.git
```

opencode:

```shell
# Show all installable versions
asdf list-all opencode

# Install specific version
asdf install opencode latest

# Set a version globally (on your ~/.tool-versions file)
asdf global opencode latest

# Now opencode commands are available
opencode --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/petershen0307/asdf-opencode/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Peter Shen](https://github.com/petershen0307/)
