# Exercise 4: Rules

**Goal:** decide which pipelines run for branches, merge requests and tags, and which jobs run in them.

Continue in your `roman` project. Stuck in exercise 3? Copy all files from this folder over your project first.

## Core task

1. **Look before you change.** Create a branch, change a line in `README.md`, push, and open a merge request.
   Open **Build → Pipelines**. Which kind of pipeline ran, and which one does the merge request show?
2. **Merge request pipelines.** Add to `.gitlab-ci.yml`:

   ```yaml
   workflow:
     rules:
       - if: $CI_PIPELINE_SOURCE == "merge_request_event"
       - if: $CI_COMMIT_BRANCH
   ```

   Push to your branch. How many pipelines did that one push start? Compare their labels.
3. **One pipeline per push.** Between the two rules, add a rule that skips the branch pipeline when the branch
   has an open merge request:

   ```yaml
       - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS
         when: never
   ```

   Push again and check that only the merge request pipeline runs.
4. **A pipeline for a tag.** Create tags, first on the `main` branch (0.1), then on the new branch (0.2)
   (**Code->Tags**->select the branch, then **New tag**) and see what happens in **Build->Pipelines**. Why does 0.1 get a pipeline and 0.2 not?

   Add a rule on the branch that also creates a pipeline on tags:

   ```yaml
       - if: $CI_COMMIT_TAG
   ```

   Create another tag (0.3) on the branch and see what happens now in **Build->Pipelines**.

5. **Merge the MR.** And see what happens.

6. **A job for tags only.** On `main` add a `package` stage and job that runs only when `$CI_COMMIT_TAG` is set
   (`rules`), packs the app with `tar -czf roman-$CI_COMMIT_TAG.tar.gz -C build roman`, and keeps the file
   as an artifact. Push to `main`: no `package` job. Then create tag `0.4` on `main` in **Code → Tags**.

Docs: [`workflow:rules`](https://docs.gitlab.com/ci/yaml/workflow/),
[`rules`](https://docs.gitlab.com/ci/yaml/#rules),
[Merge request pipelines](https://docs.gitlab.com/ci/pipelines/merge_request_pipelines/),
[Predefined variables](https://docs.gitlab.com/ci/variables/predefined_variables/).

## Think about

- `workflow:rules` and job `rules` both use `rules`. What does each decide?
- Why must the `when: never` rule come before `if: $CI_COMMIT_BRANCH`?
- Why is `$CI_COMMIT_BRANCH` empty in a tag pipeline?

## Plus exercises

- Run `smoke-run` only in merge request pipelines and on `main` (`$CI_DEFAULT_BRANCH`).
- Make `package` a manual job with `when: manual`.
- Skip `build` and the tests when only `README.md` changed, with
  [`rules:changes`](https://docs.gitlab.com/ci/yaml/#ruleschanges). What goes wrong in a new branch?
- Test the behaviour when adding tags from your local clone.
- Echo the predefined variables CI_PIPELINE_SOURCE, CI_COMMIT_BRANCH, etc. in your pipeline and
  inspect their values in pipelines created by different events.
