# GitLab Pipelines Workshop

Half-day workshop materials: a local GitLab lab, C++ sample app, exercises and solutions.

- Plan: [docs/workshop-plan.md](docs/workshop-plan.md)
- Decisions: [decisions.md](decisions.md)
- To-do: [todo.md](todo.md)

## Lab

- CI image (once): `docker build -t workshop-cpp:1 lab/ci-image`.
- `cd lab && docker compose up -d --wait --wait-timeout 900`; GitLab at <http://localhost:8929>, `root` / `Workshop-Pipelines-2026`.
- Reset: `docker compose down -v`.
- Status (2026-10-09): lab + CI image work on Linux (Conan/GoogleTest pipeline green, jobs spread over 2 runners). Exercises 1–2 done and reviewed. Run `scripts/check-sync.sh` after changing exercises/solutions. Next: exercise 3 (cache), on hold until Sebastiaan says go.
