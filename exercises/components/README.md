# Workshop CI/CD components

CI/CD components for the `roman` project of the GitLab pipelines workshop.

## format-check

Checks C++ formatting with `clang-format` and shows a diff for each file that needs changes. The style comes from
the project's `.clang-format`.

```yaml
include:
  - component: $CI_SERVER_FQDN/roman/components/format-check@1.0.0
    inputs:
      stage: test
      files: src/*.cpp src/*.hpp tests/*.cpp
```

Both inputs are required.

| Input | Description |
| ----- | ----------- |
| `stage` | Stage of the `format-check` job |
| `files` | Files to check, as shell globs |
