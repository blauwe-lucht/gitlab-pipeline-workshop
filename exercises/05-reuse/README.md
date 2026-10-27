# Exercise 5: Reuse

**Goal:** reuse pipeline configuration at three levels: within one YAML file, within your repository, and
across projects with a CI/CD component.

Continue in your `roman` project. Stuck in exercise 4? Copy all files from this folder over your project first.

## Core task

1. **Reuse within one file: using YAML anchors.** You will add a second job that needs the same Conan setup as
   the `build` job.
   We will move the shared setup to a *hidden job*, a job that can only be referenced, but will not be run
   on its own. A job is hidden when its name starts with a `.` (dot). In YAML you define an `anchor` by
   naming a section by using `&`. You reference it by using `<<: *`. The example below will make this more
   clear.

   Add a hidden job with a YAML anchor to `.gitlab-ci.yml`, directly after the `stages` section.
   `&conan-build` names the anchor so you can reuse it:

   ```yaml
   .conan-build: &conan-build
     variables:
       BUILD_TYPE: Release
     cache:
       key: conan
       paths:
         - .conan2/
     before_script:
       - conan profile detect --exist-ok
       - conan install . --output-folder=build --build=missing --settings=build_type=$BUILD_TYPE
       - cmake -S . -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE $EXTRA_CMAKE_ARGS
   ```

   In the existing `build` job, replace `cache` and the first three script lines with `<<: *conan-build`:

   ```yaml
   build:
     stage: build
     <<: *conan-build
     script:
       - cmake --build build
     artifacts:
       paths:
         - build/roman
         - build/roman_tests
   ```

   Then add a job that runs the tests with sanitizers. A sanitizer is a compiler option that adds runtime checks
   to your program, which then stops with a report when it hits a bug that normal tests can miss.
   `address` finds memory errors, such as reading past the end of an array or using freed memory;
   `undefined` finds undefined behaviour, such as signed integer overflow. The job builds in `Debug`, so
   the reports point to the right source lines:

   ```yaml
   sanitizers:
     stage: test
     <<: *conan-build
     variables:
       BUILD_TYPE: Debug
       EXTRA_CMAKE_ARGS: -DCMAKE_CXX_FLAGS=-fsanitize=address,undefined
     script:
       - cmake --build build --target roman_tests
       - ./build/roman_tests
   ```

   Push. Do both jobs pass? In each job log, can you find the build type
   of each job?
2. **Reuse within your repository: using `include` and `extends`.** Move the section `.conan-build` to a new file `ci/templates.yml`
   and include it at the top of `.gitlab-ci.yml`:

   ```yaml
   include:
     - local: ci/templates.yml
   ```

   Push, open **Build → Pipelines** and see two failing pipelines (remember why?). Open one of the pipelines and read the error. YAML anchors can not be defined in a different
   file then where they are used. Fix the error by replacing each `<<: *conan-build` with
   `extends: .conan-build`, remove `&conan-build` from the `.conan-build` section and push again.
3. **Reuse across projects: using a CI/CD component.** A component is a reusable part of a pipeline definition that lives in its own project.
   - In GitLab, create a blank project `components` in the group `roman`, next to your `roman` project,
     without a README.
   - Clone it, copy all files from [`exercises/components`](../components) into it, and push.
   - Create tag `1.0.0` in **Code → Tags → New tag**.

   Read `templates/format-check.yml`. The `spec: inputs` header above `---` lists the component's inputs:
   parameters that a project sets when it includes the component. Below `---`, `$[[ inputs.stage ]]` and
   `$[[ inputs.files ]]` are replaced with their values. `format-check` has two inputs: `stage` (the job's stage)
   and `files` (the files to check). Neither has a `default`, so you must set both.

   Then, in the `roman` project, add a `.clang-format` file in the root of the project:

   ```yaml
   BasedOnStyle: Google
   ColumnLimit: 100
   AllowShortCaseLabelsOnASingleLine: true
   ```

   And add the component with its inputs to the `include` list at the top of `.gitlab-ci.yml`, below
   `- local: ci/templates.yml`:

   ```yaml
     - component: $CI_SERVER_FQDN/roman/components/format-check@1.0.0
       inputs:
         stage: test
         files: src/*.cpp src/*.hpp tests/*.cpp
   ```

   Push. The `format-check` job fails. Its log shows a diff: lines with `-` are your code, lines with `+` are
   how `clang-format` wants them. Fix the code and push until the job passes.

Docs: [Optimize GitLab CI/CD configuration files](https://docs.gitlab.com/ci/yaml/yaml_optimization/),
[`include`](https://docs.gitlab.com/ci/yaml/#include), [`extends`](https://docs.gitlab.com/ci/yaml/#extends),
[CI/CD components](https://docs.gitlab.com/ci/components/), [Inputs](https://docs.gitlab.com/ci/inputs/).

## Think about

- `sanitizers` has its own `variables`. With `<<:`, what happens to `BUILD_TYPE: Release` from the anchor?
  And with `extends`?
- Why do anchors only work within one file, while `extends` also works across included files?
- When is `include: local` enough, and when do you need a component?
- Why include `format-check@1.0.0` and not `format-check@main`?

## Plus exercises

- Give `format-check` its own `check` stage before `build`.
- Reuse only the `before_script` of `.conan-build` in another job with
  [`!reference`](https://docs.gitlab.com/ci/yaml/yaml_optimization/).
- Add a second component to `components`, for example for the `sanitizers` job, with `spec: inputs`.
  Tag `1.1.0` and include it in `roman`.
- Publish your component in the [CI/CD Catalog](https://docs.gitlab.com/ci/components/).
