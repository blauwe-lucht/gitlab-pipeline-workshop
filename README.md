# GitLab Pipelines Workshop

Build a CI/CD pipeline step by step for `roman`, a small C++ console app that converts Roman numerals:
`roman MCMXCIV` prints `1994`. Everything runs on your own laptop: a local GitLab with two runners.

## What you need

- Rancher Desktop with the **dockerd (moby)** container engine.
- Git and VS Code.
- A local clone of this repository.

## Start the lab

From the root of this repository:

```sh
cd lab
docker build -t workshop-cpp:1 ci-image
docker compose up -d --wait
```

- The first command builds the CI image once: Ubuntu 24.04 with GCC 13, Clang 18 (clang-tidy, clang-format),
  CMake, Ninja, ccache, curl and Conan 2. Jobs use it with `image: workshop-cpp:1`.
- The second starts GitLab and the runners. The first start takes about 3–5 minutes once the images are pulled.
  It returns when GitLab is ready and both runners are registered and verified.

Then log in:

- URL: <http://localhost:8929>
- User: `root`
- Password: `Workshop-Pipelines-Lab` (override with the `GITLAB_ROOT_PASSWORD` environment variable before the first start)

**Admin → CI/CD → Runners** shows `workshop-runner-1` and `workshop-runner-2` as online.

## Exercises

Start with exercise 1; its README explains how to create your project. Each exercise builds on the previous one.
Stuck or late? Each exercise folder is a complete starting point: copy it over your project and continue.

| # | Exercise | You learn |
| - | -------- | --------- |
| 1 | [Stages and jobs](exercises/01-stages-and-jobs/README.md) | Jobs, stages, reading a red pipeline |
| 2 | [Artifacts](exercises/02-artifacts/README.md) | Build once, test reports, downloading the app |
| 3 | [Cache](exercises/03-cache/README.md) | Reusing downloaded dependencies |
| 4 | [Rules](exercises/04-rules/README.md) | Branch, merge request and tag pipelines; jobs for tags only |
| 5 | [Reuse](exercises/05-reuse/README.md) | YAML anchors, `include` and `extends`, CI/CD components |
| – | [Final solution](solutions/final/README.md) | Rules, `needs`, secrets, reuse and releases, all together |

Solutions are in [`solutions/`](solutions/).

## How the lab works

- **GitLab CE** runs in one container; your browser reaches it at `localhost:8929`.
- **Two runners** (in one `gitlab-runner` container) pick up jobs, one job each, so two jobs can run at the same time.
  They are registered automatically on first start.
- **Each job runs in its own container**, next to the runner container, started through the Docker socket.
  Job containers reach GitLab at `gitlab:8929` and share one cache volume.

## Stop and remove

From the `lab` folder:

```sh
docker compose stop        # keep your projects
docker compose down -v     # remove everything, including all data
```

## Troubleshooting

| Symptom | Fix |
| ------- | --- |
| `container gitlab is unhealthy` | Check memory (WSL2 needs ≥ 8 GB), then `docker compose logs gitlab`. |
| `runner-init didn't complete successfully` | `docker compose logs runner-init`, then `docker compose up -d --wait` again. |
| Port 8929 in use | Stop the program using it. |
| Job cannot clone or reach GitLab | Check that the `gitlab-lab` network exists: `docker network ls`. |
