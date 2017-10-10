# Amazon ECS Container Agent

This builds an Amazon ECS Container Agent, with some patches applied for Remind's use.

## Patches

1. [1-tty](./patches/1-tty): This patch provides a method to pass down the `-t` (allocate TTY) and `-i` (open stdin) flags of `docker run`, so that Empire can attach to these tasks. (From https://github.com/aws/amazon-ecs-agent/compare/master...ejholmes:tty)
2. [2-pids-limit](./patches/2-pids-limit): This patch will automatically remove the `nproc` ulimit, and replace it with the `--pids-limit` flag of Docker run (From https://github.com/aws/amazon-ecs-agent/compare/master...ejholmes:pids-limit)

## Updating to a new release

1. Bump `REVISION` in [Makefile](./Makefile)
2. Run `make bin/amazon-ecs-agent` again.
