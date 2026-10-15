# GitLab pipelines: best practices

What we practised in the workshop, grouped by goal. Examples refer to [`solutions/final`](../solutions/final/).

## Reproducible

- **Pin versions** of images and tools (`workshop-cpp:1`, `conan==2.33.0`, `gtest/1.18.0`), never `latest`.
  Why: the same commit builds the same way next month.
- **Define the CI image as code:** a Dockerfile under version control, built on purpose and published with a
  version tag. At work that is usually its own repository and pipeline; in this workshop it is `lab/ci-image/`.
- **Never rely on the cache for correctness.** A job must also work with an empty cache.

## Fast

- **Fail fast:** cheap checks first (`format` in stage `check`), heavy checks where they matter (`.thorough`).
- **Build once,** pass the result on as artifacts instead of rebuilding in every job (`build`).
- **Use `needs`** so jobs start as soon as their inputs are ready (`unit-tests`, `tidy`, `sanitizers`).
- **Cache dependencies** with a key based on what determines their content
  (`key:files: [conanfile.txt]`).
- **Download only what a job needs:** `needs` or `dependencies` instead of all earlier artifacts.
- **Split jobs where it pays off:** separate jobs for different failure reasons, parallel work or different rules;
  keep steps that always run together in one job. Every job costs a container start, a clone and a cache restore.
- **Few stages:** a handful of meaningful phases (`check`, `build`, `test`, `release`), not one stage per job.

## Clear feedback

- **Publish test reports** (`artifacts:reports:junit`) and upload them with `when: always`, so failures show up.
- **Run the app** in the pipeline, not only its unit tests (`smoke-run`).
- **Run the full checks in merge requests,** before code reaches `main`.
- **One pipeline per change:** `workflow:rules` to avoid a branch and a merge request pipeline for the same push.
- **Keep job logs focused:** quiet noisy tools where possible, so the line that explains a failure is easy to find.

## Secure

- **Protect publishing credentials:** masked *and* protected variables, used only by release jobs.
- **Protect release tags** (`v*`) and `main`, so only trusted people can trigger a release.
- **Least privilege:** use the short-lived `CI_JOB_TOKEN` where possible instead of personal or project
  access tokens.
- **Never print secrets,** even masked ones: masking only hides exact matches in the log.
- **Keep separate caches for protected refs** (GitLab's default) against cache poisoning.

## Maintainable

- **Keep logic in scripts, not in YAML:** put build, test and release steps in script files in the repo and let
  `.gitlab-ci.yml` only decide when and where they run. You can then run the same scripts locally, in the CI
  image, and test pipeline changes without a push for every attempt (`ci/*.sh`).
- **DRY:** shared setup in hidden jobs (`.conan-build`), reused with `extends`, kept in `include` files.
- **Validate before pushing:** the pipeline editor or the CI Lint API.
- **Clean up:** give artifacts an `expire_in`, so old build output does not pile up on the server.
