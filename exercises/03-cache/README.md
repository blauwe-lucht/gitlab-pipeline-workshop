# Exercise 3: Cache

**Goal:** stop downloading the same dependencies in every pipeline.

Continue in your `roman` project. Stuck in exercise 2? Copy all files from this folder over your project first.

## Core task

1. **Look before you change.** Open the log of the `build` job and find the line below
   `======== Computing dependency graph ========` where Conan says
   where `gtest/1.18.0` comes from. Run the pipeline again from **Build → Pipelines**. It has downloaded
   gtest all over again.
2. **Add a cache.** GitLab can only cache paths inside the project folder, so let Conan store its packages there:

   ```yaml
   variables:
     CONAN_HOME: $CI_PROJECT_DIR/.conan2
   ```

   The default Conan profile lives in the old location, so create one first in the `build` job:
   `conan profile detect --exist-ok`.
   Then cache `.conan2/` in the `build` job, and add `.conan2/` to `.gitignore`.
3. **Compare.** Push, then run the pipeline once more. In the second `build` log, find:
   - the runner's lines about restoring the cache at the start of the job;
   - Conan's line for `gtest/1.18.0`. What changed?

Docs: [`cache`](https://docs.gitlab.com/ci/yaml/#cache), [Caching in GitLab CI/CD](https://docs.gitlab.com/ci/caching/).

## Think about

- The runner adds `-protected` to your cache key on `main`. Why?
- What is the difference between a cache and an artifact?
- Every `build` job saves the cache again, even when nothing changed. Is that needed?

## Stretch

- Create a branch, push and inspect the name of the cache in the build results.
- Make the cache key change when `conanfile.txt` changes, with [`cache:key:files`](https://docs.gitlab.com/ci/yaml/#cachekeyfiles).
- Only save the cache when needed, with [`cache:policy`](https://docs.gitlab.com/ci/yaml/#cachepolicy).
- Speed up compiling with `ccache`. It is in the CI image.
