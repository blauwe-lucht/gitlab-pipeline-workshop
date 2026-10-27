# GitLab Pipelines Workshop

Half-day workshop materials: a local GitLab lab, C++ sample app, exercises and solutions.

- Plan: [docs/workshop-plan.md](docs/workshop-plan.md)
- Decisions: [decisions.md](decisions.md)
- To-do: [todo.md](todo.md)
- Teaching notes: [docs/teaching-notes.md](docs/teaching-notes.md)

## Lab

- CI image (once): `docker build -t workshop-cpp:1 lab/ci-image`.
- `cd lab && docker compose up -d --wait --wait-timeout 900`; GitLab at <http://localhost:8929>, `root` / `Workshop-Pipelines-Lab`.
- Reset: `docker compose down -v`.
- Status (2026-10-27): lab + CI image work on Linux (Conan/GoogleTest pipeline green, jobs spread over 2 runners). Exercises 1–4 done and reviewed; exercise 5 (reuse; students create component project `roman/components` from `exercises/components`) built, awaiting lab check and review; `solutions/final` covers topics 6–8 (awaiting review). Run `scripts/check-sync.sh` after changing exercises/solutions. Next: docs (`best-practices.md`, `pre-workshop.md`).
