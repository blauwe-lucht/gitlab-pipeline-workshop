# Exercise 1: Stages and jobs

**Goal:** build and test the `roman` app on every push, with jobs grouped in stages.

`roman` converts a Roman numeral to a decimal number: `roman MCMXCIV` prints `1994`.

## Set up your project (once)

1. Open <http://localhost:8929> and log in as `root`.
2. Select **Create new** (+) → **New project/repository** → **Create blank project**.
   Name it `roman` and **uncheck** "Initialize repository with a README". Select **Create project**.
3. Clone it: `git clone http://root@localhost:8929/root/roman.git`.
   When asked, enter password `Workshop-Pipelines-2026`.
4. Copy all files from this folder into your clone, including the hidden `.gitlab-ci.yml` and `.gitignore`.
5. Commit and push from VS Code.
6. In GitLab, open **Build → Pipelines**. Open the `hello` job: it prints the tool versions of the CI image.

## Core task

Replace the `hello` job with two stages and three jobs:

| Stage | Job | Does |
| ----- | --- | ---- |
| `build` | `build` | Builds the app and the tests |
| `test` | `unit-tests` | Builds, then runs `./build/roman_tests` |
| `test` | `smoke-run` | Builds, then runs `./build/roman MCMXCIV` |

Building takes three commands:

```sh
conan install . --output-folder=build --build=missing
cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

Push. The pipeline turns red. Find out why in the job log, fix the bug in `src/` (ask a developer for help
if needed), and push again until it is green.

Docs: [`stages`](https://docs.gitlab.com/ci/yaml/#stages), [`script`](https://docs.gitlab.com/ci/yaml/#script).

## Think about

- Why do `unit-tests` and `smoke-run` run at the same time?
- What happens to the `test` stage when `build` fails?
- Every job builds the app again. Why? (Exercise 2 fixes this.)

## Stretch

- Build with both GCC and Clang using [`parallel:matrix`](https://docs.gitlab.com/ci/yaml/#parallelmatrix).
  Hint: set `CC`/`CXX` and run `conan profile detect --force` first.
- Search for a way to validate the `.gitlab-ci.yml` file before it's pushed.
