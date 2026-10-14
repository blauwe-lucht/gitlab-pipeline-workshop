# Final solution: everything together

The complete pipeline for `roman`, showing every workshop topic. Copy all files from this folder over your project to try it.

## Where to find each topic

| Topic | Where | What to look at |
| ----- | ----- | --------------- |
| Stages and jobs | `.gitlab-ci.yml` | `check` → `build` → `test` → `release` |
| Artifacts | `build`, `unit-tests` | Build once, reuse in later jobs; `expire_in`; JUnit report |
| Cache | `.conan-build` in `ci/templates.yml` | Key from `conanfile.txt`, separate per build type |
| Rules | `workflow:rules`, `.thorough` | Pipelines for merge requests, branches and tags, no duplicates; heavy checks only in merge requests and on `main` |
| `needs` | `unit-tests`, `smoke-run`, `tidy`, `sanitizers` | Tests start as soon as `build` is done; `tidy` and `sanitizers` start right away |
| Variables and secrets | `release` | Masked, protected `RELEASE_SECRET`: shown as `[MASKED]`, empty on unprotected tags |
| Reuse | `include`, `extends` | Templates in `ci/templates.yml` |
| Environments | `release` | Manual job on tags; uploads `roman` to the package registry |

## One-time project setup (for the release)

1. **Settings → Repository → Protected tags:** protect `v*`.
2. **Settings → CI/CD → Variables → Add variable:** key `RELEASE_SECRET`, any value of 8+ characters
   without spaces. Set **Visibility** to **Masked** and tick **Protect variable**.

## Try it

- **Push to a branch:** quick checks only (format, build, tests).
- **Open a merge request** and push again: one merge request pipeline with all checks, including `tidy` and `sanitizers`.
- **Tag `v1.0.0`:** run the manual `release` job. Find `[MASKED]` in its log, then open **Deploy → Package registry**.
- **Tag `test-1`** (not protected): the `release` job fails, because `RELEASE_SECRET` is empty.
