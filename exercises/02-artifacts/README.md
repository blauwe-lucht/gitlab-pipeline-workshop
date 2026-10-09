# Exercise 2: Artifacts

**Goal:** build once, reuse the result in later jobs, and see test results in GitLab.

Continue in your `roman` project. Stuck in exercise 1? Copy all files from this folder over your project first.

## Core task

1. **Build once.** Save `build/roman` and `build/roman_tests` as artifacts of the `build` job.
   Remove the build commands from `unit-tests` and `smoke-run`; they use the artifacts instead.
   Push, and compare the pipeline duration with exercise 1.
2. **Test report.** Run the tests with `./build/roman_tests --gtest_output=xml:report.xml`
   and publish `report.xml` as a JUnit report. Open the pipeline and look at the **Tests** tab.
3. **Report in a merge request.** Create a branch, break a test, push, and open a merge request.
   Find the test summary in the merge request. No report? Find out when artifacts are uploaded.
   Close the merge request afterwards.
4. **Run the app.** On the `build` job page, download the job artifacts and unzip them.
   In the unzipped folder, run `roman` on your birth year:

   ```sh
   docker run --rm -v "${PWD}/build:/w:ro" alpine:3.24.2 /w/roman MCMLXXX
   ```

Docs: [`artifacts`](https://docs.gitlab.com/ci/yaml/#artifacts), [`artifacts:reports:junit`](https://docs.gitlab.com/ci/yaml/artifacts_reports/#artifactsreportsjunit).

## Think about

- Why does the report need to be uploaded even when the tests fail?
- How long does GitLab keep your artifacts? What if every pipeline kept 1 GB?

## Stretch

- Keep artifacts only as long as useful with [`expire_in`](https://docs.gitlab.com/ci/yaml/#artifactsexpire_in).
- Show test coverage in GitLab. The CI image has no coverage tool yet.
