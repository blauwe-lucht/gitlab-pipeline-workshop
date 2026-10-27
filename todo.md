# To-do

- [ ] Verify lab on Windows 11 + Rancher Desktop (socket mount, bind-mounted script; executable bit of unzipped artifact and `${PWD}/build` path in `docker run -v`).
- [ ] Verify fresh lab setup with shared cache volume (`down -v` + `up`; running lab was patched in place for the cache volume and `pre_build_script`).
- [ ] Review `solutions/final` (Sebastiaan); check UI paths in its README (Protected tags, Variables, Package registry).
- [ ] Verify exercise 5 in the lab: every core step (incl. the anchor error after the move to `ci/templates.yml` and `include: component` from `roman/components`), `solutions/05-reuse` green.
- [ ] Time exercises 1–5 in a dry run: the agenda gives them one hour.
- [ ] Optional later: separate exercises 6–8, worked back from `solutions/final`.
- [ ] `docs/pre-workshop.md` (include CI image build and runner helper image pre-pull; the image now includes `curl`, so rebuild it).
