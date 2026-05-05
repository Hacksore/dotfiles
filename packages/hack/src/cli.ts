#!/usr/bin/env node

import { type Command, Option, program } from "commander";
import { handleBuild } from "./commands/build.ts";
import { handleTest } from "./commands/test.ts";
import {
  CONTAINER_RUNTIMES,
  type ContainerRuntime,
  DEFAULT_CONTAINER_RUNTIME,
  resolveContainerRuntime,
} from "./constants.ts";
import { parseFlagToBoolean } from "./utils.ts";

function addContainerRuntimeOption(cmd: Command) {
  cmd.addOption(
    new Option("--runtime <runtime>", "container runtime to use for build/test")
      .choices([...CONTAINER_RUNTIMES])
      .default(process.env.HACK_CONTAINER_RUNTIME ?? DEFAULT_CONTAINER_RUNTIME),
  );
}

/**
 * Adds test options to a command and returns a function to transform the options
 * to match what handleTest expects.
 */
function addTestOptions(cmd: Command) {
  cmd
    .option(
      "--frozen-lock [value]",
      "if it should use the existing commit lazy lock file",
      false,
    )
    .option(
      "-r, --remote",
      "use the remote dotfiles from github default branch",
      false,
    )
    .option("-s, --skip-cargo [value]", "weahter to skip cargo install", false)
    .option("-n, --nightly", "use nightly for bleeding edge neovim")
    .allowUnknownOption();
}

function transformContainerRuntimeOption(opts: {
  runtime?: string;
}): ContainerRuntime {
  return resolveContainerRuntime(opts.runtime);
}

/**
 * Transforms commander options to match handleTest's expected format
 */
function transformTestOptions(opts: {
  frozenLock?: boolean | string;
  remote?: boolean;
  skipCargo?: boolean | string;
  nightly?: boolean;
  runtime?: string;
}) {
  return {
    nightly: Boolean(opts.nightly),
    frozenLock: parseFlagToBoolean(opts.frozenLock),
    remote: Boolean(opts.remote),
    skipCargo: parseFlagToBoolean(opts.skipCargo),
    runtime: transformContainerRuntimeOption(opts),
  };
}

const buildCommand = program
  .command("build")
  .description("build hacksore/nvim container test image")
  .allowUnknownOption();
addContainerRuntimeOption(buildCommand);
buildCommand.action((_opts, command) => {
  return handleBuild({
    runtime: transformContainerRuntimeOption(command.optsWithGlobals()),
  });
});

const testCommand = program
  .command("test")
  .description("Run the hacksore/nvim container test image");
addContainerRuntimeOption(testCommand);
addTestOptions(testCommand);
testCommand.action((_opts, command) => {
  return handleTest(transformTestOptions(command.optsWithGlobals()));
});

program
  .name("hack")
  .description(
    "🤓 CLI to manage various things for building my neovim config\nBy default it will run build and test for convenience",
  )
  .option("-v, --version", "output the current version")
  .allowExcessArguments()
  .allowUnknownOption();
addContainerRuntimeOption(program);
addTestOptions(program);
program.action(async (opts) => {
  const runtime = transformContainerRuntimeOption(opts);
  await handleBuild({ runtime });
  await handleTest(transformTestOptions(opts));
});
program.parse();
