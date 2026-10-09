# GitLab Pipelines Workshop — Plan

## Scope

- Half day (3h): basics, best practices, student show-and-tell + Q&A.
- Students: Windows 11 + Rancher Desktop (dockerd/moby engine). Some already wrote pipelines on the company GitLab.
- Each student runs GitLab locally via Docker Compose. No proxy.
- Sample app: Roman numeral → decimal console app, Conan 2 with CMake, GoogleTest (AAA-style tests).
- No slides; repo materials only.

## Deliverables

```text
.gitattributes          Force LF for scripts and files used in containers
lab/
  compose.yaml          GitLab CE + runner-init + GitLab Runner (Docker executor)
  register-runners.sh   Run by runner-init: creates and configures 2 runners
  ci-image/Dockerfile   Custom CI image `workshop-cpp:1`, built locally
  README.md             Start, login, teardown, troubleshooting
exercises/
  01-…08-…/             Self-contained start: app + .gitlab-ci.yml + README (core task, stretch tasks)
docs/
  best-practices.md     One-page checklist
  pre-workshop.md       Checklist to send students in advance
solutions/              Per exercise the complete solution; solutions/0N = exercises/0N+1
scripts/check-sync.sh   Verifies that sync
```

## Lab requirements

- Latest stable, pinned: `gitlab/gitlab-ce:19.4.1-ce.0`, `gitlab/gitlab-runner:v19.4.1` (verified 2026-10-08).
- Named volumes, healthcheck.
- Tune GitLab for laptops: fewer Puma workers, Prometheus disabled.
- Git over HTTP only (no SSH port).
- Networking: browser uses `http://localhost:8929`; runner and job containers use `http://gitlab:8929` on the compose network.
- Fully automatic runner registration via an init container:
  1. Wait for GitLab healthy.
  2. Create a root token with `create_runner` scope (`gitlab-rails runner`).
  3. Create 2 instance runners via `POST /api/v4/user/runners`.
  4. Write `config.toml` with both runners (`concurrent = 2`, `limit = 1` each).
  5. Idempotent: skip when already configured.
- CI image: built locally once; runner uses `pull_policy = if-not-present`.
- Solutions are verified by running them in the lab (green pipeline).

## Exercises

Student flow: create empty GitLab project, clone, copy exercise folder in, push, inspect pipeline. Each README has a core task (~10 min) and stretch tasks for advanced students.

1. **Stages and jobs**: build, test (unit tests + smoke run); fix a planted bug.
2. **Artifacts**: pass build output between jobs; GoogleTest XML as JUnit report in MRs.
3. **Cache**: fetched dependencies, `ccache` between pipelines (keep simple).
4. **Rules**: branches vs merge requests vs tags.
5. **`needs` / DAG**: `clang-format`, `clang-tidy` and sanitizer build in parallel with tests.
6. **Variables and secrets**: masked and protected variables.
7. **Reuse**: `include` and `extends` templates.
8. **Environments**: manual release job on tags; publish to the generic package registry (stand-in for Nexus).

## Agenda

| Time | Block |
| ---- | ----- |
| 0:00 | Intro, start lab |
| 0:15 | Basics: exercises 1–4 |
| 1:15 | Break |
| 1:25 | Best practices: exercises 5–8, checklist |
| 2:15 | Student show-and-tell, Q&A |
| 2:50 | Wrap-up |

## Best-practices checklist (topics)

- Pin image versions.
- Fail fast: cheap checks first.
- Cache dependencies; keep artifacts small with expiry.
- Least privilege: protected variables, protected branches.
- DRY with `include` / `extends`.
- Keep pipelines short; use `needs` for parallelism.
- Validate with CI Lint before pushing.

## Pre-workshop checklist (students)

- Rancher Desktop installed, container engine set to dockerd (moby).
- WSL2 memory ≥ 8 GB (`.wslconfig`); ~15 GB free disk (to verify).
- Git installed; repo cloned.
- Images pulled and CI image built in advance.
- Lab started once successfully (`docker compose up`), then stopped.
- Bring an existing pipeline (company GitLab) for show-and-tell.
