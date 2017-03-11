# Amazon ECS Container Agent

This builds an Amazon ECS Container Agent, with some patches applied for Remind's use.

## Patches

1. [1-tty](./patches/1-tty): This patch provides a method to pass down the `-t` (allocate TTY) and `-i` (open stdin) flags of `docker run`, so that Empire can attach to these tasks. (From https://github.com/aws/amazon-ecs-agent/compare/master...ejholmes:tty)

## Updating to a new release

1. Bump `REVISION` in [Makefile](./Makefile)
2. Run `make bin/amazon-ecs-agent` again.
