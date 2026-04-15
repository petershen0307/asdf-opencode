# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test opencode https://github.com/petershen0307/asdf-opencode.git "opencode --help"
```

Tests are automatically run in GitHub Actions on push and PR.
