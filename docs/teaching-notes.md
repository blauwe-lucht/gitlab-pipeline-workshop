# Teaching notes

- Why CI/CD: every push is built and tested the same way; fast feedback; no "works on my machine".
- The lab: GitLab CE + 2 runners on your laptop; jobs run in containers.
- The app: `roman`, a C++ console app with GoogleTest tests, built with Conan + CMake.

## Concepts

| Concept | One-liner | Exercise |
| ------- | --------- | -------- |
| GitLab | DevOps platform: Git hosting, merge requests, issues, registries and CI/CD in one product | 1 |
| GitLab CI/CD | The CI/CD system in GitLab: on each event reads `.gitlab-ci.yml`, creates the pipeline and its jobs, hands them to runners and stores logs, artifacts and reports. Runs no jobs itself; the cache stays with the runners | 1 |
| Pipeline | Used for both the definition (`.gitlab-ci.yml`, edited in the pipeline editor) and one run of it, started by a push, MR, tag, schedule… The context tells which | 1 |
| Stage | Group of jobs; stages run in order, jobs within a stage in parallel | 1 |
| Job | Commands that run in a fresh container | 1 |
| Runner / executor | Program that picks up jobs; the Docker executor starts a container per job | 1 |
| Image | The container a job runs in (`workshop-cpp:1`) | 1 |
| Artifact | Job output kept by GitLab, passed to later jobs, downloadable | 2 |
| Report | Artifact GitLab understands, e.g. JUnit test results | 2 |
| Cache | Speed-up between pipelines; may be missing, never relied on for correctness | 3 |
| `needs` / DAG | Start a job when its inputs are ready, not when its stage starts | final |
| `rules` / `workflow` | Decide whether a job or pipeline runs at all | final |
| Variables | Predefined (`CI_*`), project, masked, protected | final |
| `include` / `extends` | Reuse configuration across files and jobs | final |
| Environment | Where a job deploys to; history of deployments | final |

## Terms worth defining

- Protected branch / tag: only Maintainers can push; gets protected variables and its own cache.
- Ref: the branch or tag a pipeline runs for. A tag pipeline's ref is the tag, not the branch.
- Merge request pipeline vs branch pipeline.
- Job token (`CI_JOB_TOKEN`): GitLab creates it for each job and it expires when the job ends. It reaches only a
  limited set of GitLab features (repositories, artifacts, packages, some API endpoints), with the permissions of
  whoever triggered the pipeline. By default it only works for its own project.
- Manual job: waits until someone starts it.

## Quirks (we hit all of these)

- **`:` in a script line** makes YAML read it as a key: GitLab creates no jobs. Quote the whole line.
- **Jobs start from scratch:** no files from earlier jobs unless they are artifacts (or cache).
- **Later stages get all earlier artifacts** by default; `dependencies` or `needs` limit that.
- **Artifacts upload only on success** by default: test reports vanish on failing tests without `when: always`.
- **Cache lives only inside the project folder:** point tool caches there (`CONAN_HOME`, `CCACHE_DIR`).
- **Cache key gets `-protected`** on protected refs: separate caches against cache poisoning.
- **Cache is saved after every job** (`pull-push`), even when nothing changed.
- **Protected variables are empty** on unprotected branches and tags, not `[MASKED]`.
- **Masking hides values in logs only;** a job can still leak them (`base64`).
- **`extends` merges hashes but replaces arrays:** a job's own `script` or `rules` replaces the template's.
- **Branch + merge request = two pipelines** for one push, unless `workflow:rules` prevents it.
- **Manual jobs on tags** leave the pipeline waiting until someone starts them.
- **`localhost` inside a job container** is the container itself, not your laptop.

## Best practices

See [best-practices.md](best-practices.md).
