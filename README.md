# Saxophone

Nerves project experiment. Aims:

1. Get new project on Raspberry PI, from scratch with Nerves
2. Control GPIO from simple web app
3. Trigger the M&Ms saxophonist by toggling a GPIO port on an off
4. Integrate with Slack, so the Saxophonist and be triggered from there.

## Notes

### Get on the PI.

1. Get a plug router into the supervision tree, so we know it's all working.
2. Add ethernet in mix.exs and supervision tree so we can get to the app once it's deployed. (Maybe only in prod?)
3. Make sure you're set up with `brew nerves`, & exrm
4. Set up nerves for project. Remember to source nerves-env.sh & MIX_ENV=prod
5. Ensure everything is clean before `make all`.
6. From a clean build the `ale` binary doesn't make it to `_build/` and subsequently the `rel/` directories. After first build `rm -rf _build` and `make compile`
7. Add the `Gpio` worker for the port into the supervision tree.
