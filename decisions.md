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
| 2026-10-09 | Exercise 1 uses stages `build` → `test` (no separate `configure` job); each job rebuilds. | Without artifacts a configure job is useless; the duplication motivates exercises 2, 3 and 7. |
| 2026-10-09 | Planted bug: `'D'` maps to 50; one test fails. | Students experience a red pipeline and fix it. |
| 2026-10-09 | `solutions/0N` has no README; sync check ignores `README.md`. | Each exercise has its own README; solutions are code only. |
| 2026-10-09 | Stretch tasks may be open-ended and need not have a verified answer; core tasks and solutions are always verified in the lab. | Students learn from searching, even without finding a solution. |
| 2026-10-09 | Exercise 2 core: download the `roman` artifact and run it in an Alpine container (`docker run ... alpine:3.24.2 /w/roman <numeral>`). | Concrete, personal result; static binary verified to run in Alpine. |
| 2026-10-09 | No native Windows build (MinGW). | Keeps the CI image small and the exercises focused. |
| 2026-10-09 | Clone with `http://root@localhost:8929/...`. | Verified working push from host; avoids username prompt mistakes. |
| 2026-10-09 | Exercise 2: `build` saves `build/roman` + `build/roman_tests`; `unit-tests` publishes JUnit with `artifacts:when: always`. | Build once; report must survive failing tests (shown in MR). |
