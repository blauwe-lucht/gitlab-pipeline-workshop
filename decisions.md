# Decisions

| Date | Decision | Why |
| ---- | -------- | --- |
| 2026-10-08 | Workshop is 3h; show-and-tell 35 min. | Fixed half-day slot. |
| 2026-10-08 | Students use Windows 11 + Rancher Desktop (dockerd engine). | Company standard; Docker executor needs the Docker socket. |
| 2026-10-08 | Pin latest stable: GitLab CE 19.4.1, Runner v19.4.1. | Reproducible lab; no need to match company GitLab version. |
| 2026-10-08 | Runner registration fully automatic via `runner-init` container. | Swift start; no UI token copying. |
| 2026-10-08 | 2 runners, `concurrent = 2`. | Lets `needs`/parallel jobs actually run in parallel. |
| 2026-10-08 | Git over HTTP only, no SSH port. | Avoids port conflicts on Windows. |
| 2026-10-08 | GitLab on port 8929 (not 8080). | Puma uses 8080 internally; same URL host-side and internally. |
| 2026-10-08 | Own readiness healthcheck instead of the image's. | Image healthcheck reports healthy before first reconfigure. |
| 2026-10-08 | Conan 2. | Current major version. |
| 2026-10-08 | Custom CI image, built locally; runner `pull_policy = if-not-present`. | No ready-made image fits; avoids a registry. |
| 2026-10-08 | Exercise format decided after the lab works. | Think big, start small. |
| 2026-10-09 | No ready-made CI image: official `conanio/*` images are deprecated (archived 2025-12), Ubuntu 16.04-based, x64 only; community images are single-maintainer and not checked for clang tools or ccache. | Checked Docker Hub and conan-docker-tools. |
| 2026-10-09 | `limit = 1` per runner. | Parallel jobs spread over both runners, visible in the UI. |
| 2026-10-09 | CI image `workshop-cpp:1`: `ubuntu:noble-20260911`, apt toolchain (`build-essential`, clang tools, CMake, Ninja, ccache), Conan 2.33.0 via pipx. | 24.04 LTS tools are recipe-compatible; `build-essential` needed because Conan builds deps with Makefiles. |
| 2026-10-09 | CI image runs a full `apt-get upgrade` (not security-only). | Simpler Dockerfile; fixes base-image CVE-2026-84782 (OpenSSL). VS Code's warning on `FROM` stays: it checks the base image only. |
| 2026-10-09 | Remove pipx's shared pip after installing Conan. | Only needed to install; its bundled libraries caused 4 HIGH findings. |
| 2026-10-09 | Accept remaining 142 HIGH/CRITICAL findings in `linux-libc-dev`. | Kernel headers needed by `build-essential`; containers use the host kernel; no Ubuntu fix. |
| 2026-10-09 | Students work locally in an IDE: create empty GitLab project, clone, copy exercise files, push. | Inexperienced students must learn to use an IDE too. |
| 2026-10-09 | Each exercise folder is self-contained (app + starting `.gitlab-ci.yml`); `solutions/0N` = `exercises/0N+1`, kept in sync. | Copying the next folder is the catch-up path. |
| 2026-10-09 | Sample: console app converting Roman numerals to decimal (not a library). | Students get something they can run. |
| 2026-10-09 | GitLab generic package registry stands in for Nexus (exercise 8). | Built into CE Free; same publish-on-tag idea. |
| 2026-10-09 | Exercise 1 uses stages `build` → `test` (no separate `configure` job); each job rebuilds. | Without artifacts a configure job is useless; the duplication motivates exercises 2, 3 and 5. |
| 2026-10-09 | Planted bug: `'D'` maps to 50; one test fails. | Students experience a red pipeline and fix it. |
| 2026-10-09 | `solutions/0N` has no README; sync check ignores `README.md`. | Each exercise has its own README; solutions are code only. |
| 2026-10-09 | Stretch tasks may be open-ended and need not have a verified answer; core tasks and solutions are always verified in the lab. | Students learn from searching, even without finding a solution. |
| 2026-10-09 | Exercise 2 core: download the `roman` artifact and run it in an Alpine container (`docker run ... alpine:3.24.2 /w/roman <numeral>`). | Concrete, personal result; static binary verified to run in Alpine. |
| 2026-10-09 | No native Windows build (MinGW). | Keeps the CI image small and the exercises focused. |
| 2026-10-09 | Clone with `http://root@localhost:8929/...`. | Verified working push from host; avoids username prompt mistakes. |
| 2026-10-09 | Exercise 2: `build` saves `build/roman` + `build/roman_tests`; `unit-tests` publishes JUnit with `artifacts:when: always`. | Build once; report must survive failing tests (shown in MR). |
| 2026-10-13 | Runner healthcheck: `gitlab-runner verify`, checking exit code and output. | Image has none; `verify` exits 0 when GitLab is unreachable, so output must be checked. `--wait` now also waits for valid runners. |
| 2026-10-13 | Job containers share one named cache volume (`gitlab-lab-runner-cache`); `disable_cache = true`. | Per-runner cache volumes made a cache saved by one runner invisible to the other, and piled up outside `down -v`. |
| 2026-10-13 | Exercise 3: `CONAN_HOME` in the project dir, cache `.conan2/` (key `conan`), `conan profile detect --exist-ok`. Success is shown by log lines (`Downloaded` → `Cache`), not timing. | GoogleTest binaries come prebuilt; time savings are too small to see. |
| 2026-10-14 | No separate exercises 4–8 for now; one grand solution in `solutions/final` covers all topics and is walked through in the second block. | Not enough time to build all exercises. |
| 2026-10-14 | Secrets topic uses a masked, protected demo variable (`RELEASE_SECRET`), not a deploy token. | Good enough to show masking and protection. |
| 2026-10-14 | Runner `pre_build_script` exports `CI_API_V4_URL=http://gitlab:8929/api/v4`. | Jobs got `localhost` (the browser URL); the runner's `environment` setting cannot override it (tested). |
| 2026-10-14 | `curl` added to the CI image. | Release job uploads to the package registry; one image for all jobs. |
| 2026-10-14 | Final solution adds `.clang-format` (Google, 100 cols) and `.clang-tidy`; tests use `constexpr std::string_view`. | Clean under both tools without suppressing checks; earlier exercise code has a natural format violation (include order). |
| 2026-10-14 | Sanitizer job builds only `roman_tests`. | The app links statically, which ASan does not support. |
| 2026-10-14 | Lab README moved to the top-level `README.md` and expanded into the workshop entry point. | Students see it first when opening the repo. |
| 2026-10-14 | `solutions/final` keeps its logic in `ci/*.sh`; YAML calls them as `bash ci/<script>.sh`. | Scripts can be run and tested locally; `bash` avoids relying on the executable bit, which Git on Windows usually does not record. |
| 2026-10-14 | `solutions/final` has its own `.gitattributes` (`*.sh text eol=lf`). | CRLF from a Windows editor would break scripts in Linux jobs. |
| 2026-10-14 | Final cache key: `conanfile.txt` with the job name as prefix. | Scripts take the build type as argument; per-job caches keep the YAML simple. |
| 2026-10-15 | `best-practices.md` lists only practices to follow; GitLab/YAML quirks live in the Quirks section of `teaching-notes.md`. | Quirks are not practices; avoids duplicating them. |
| 2026-10-22 | Exercise 4 (rules): `workflow:rules` from the GitLab "switch between branch and merge request pipelines" example, built up in two steps; a tag-only `package` job (`tar` of `roman`). | The intermediate step shows duplicate pipelines; the docs example has no tag rule, so students hit "no tag pipeline" and fix it. |
| 2026-10-27 | Exercise 5 (reuse) before `needs`: YAML anchors → `include: local` + `extends` → CI/CD component, in one exercise; topics 6–8 stay in `solutions/final`. | Shows reuse at three levels; moving the anchor to another file breaks the pipeline, which motivates `extends`. |
| 2026-10-27 | Exercise 5 motivates reuse with a `sanitizers` job sharing the Conan setup (`.conan-build`, `BUILD_TYPE`, `EXTRA_CMAKE_ARGS`) with `build`. | A real second job; same sanitizer build as `solutions/final`. |
| 2026-10-27 | Students create the component project `components` themselves from the sources in `exercises/components` (`format-check`, tag `1.0.0`); writing a component of their own is a plus exercise. | They see what a component project needs (README, `templates/`, tag) without writing one in the core task. |
| 2026-10-27 | Component sources live in `exercises/components`, outside the numbered exercise folders. | Keeps `solutions/04` = `exercises/05` and the catch-up copy free of a second project. |
| 2026-10-27 | Solutions cover the core task only, not the plus exercises. | Plus exercises may be open-ended. |
| 2026-10-27 | `format-check` uses the project's `.clang-format` (from `solutions/final`); exercise code then fails only on the include order in `main.cpp`. | One quick, visible fix: red → green. |
| 2026-10-27 | `solutions/final` checks formatting with the `format-check` component (stage `check`) instead of its own script. | Matches exercise 5; the component shows a diff, not just a position. |
