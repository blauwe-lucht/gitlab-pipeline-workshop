# Lab: local GitLab + 2 runners

GitLab CE and a GitLab Runner with two registered runners (Docker executor, one job each), started with Docker Compose. Runner registration is automatic.

## Build the CI image (once)

From this `lab` folder:

```sh
docker build -t workshop-cpp:1 ci-image
```

Ubuntu 24.04 with GCC 13, Clang 18 (clang-tidy, clang-format), CMake, Ninja, ccache and Conan 2. Use it in jobs with `image: workshop-cpp:1`.

## Start

```sh
docker compose up -d --wait --wait-timeout 900
```

The first start takes about 3–5 minutes once the images are pulled. The command returns when GitLab is ready and both runners are registered.

## Log in

- URL: <http://localhost:8929>
- User: `root`
- Password: `Workshop-Pipelines-2026` (override with the `GITLAB_ROOT_PASSWORD` environment variable before the first start)

Check the runners: **Admin → CI/CD → Runners** shows `workshop-runner-1` and `workshop-runner-2` as online.

## Stop and remove

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
