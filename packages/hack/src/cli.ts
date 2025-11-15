#!/usr/bin/env node

import { type Command, program } from "commander";
import { handleBuild } from "./commands/build.ts";
import { handleTest } from "./commands/test.ts";

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

/**
 * Transforms commander options to match handleTest's expected format
 */
function transformTestOptions(opts: {
  frozenLock?: boolean | string;
  remote?: boolean;
  skipCargo?: boolean | string;
  nightly?: boolean;
}) {
  return {
    nightly: Boolean(opts.nightly),
    frozenLock: Boolean(opts.frozenLock),
    remote: Boolean(opts.remote),
    skipCargo: Boolean(opts.skipCargo),
  };
}

program
  .command("build")
  .description("build hacksore/nvim docker test image")
  .allowUnknownOption()
  .action(handleBuild);

const testCommand = program
  .command("test")
  .description("Run the hacksore/nvim docker test image");
addTestOptions(testCommand);
testCommand.action((opts) => {
  handleTest(transformTestOptions(opts));
});

program
  .name("hack")
  .description(
    "🤓 CLI to manage various things for building my neovim config\nBy default it will run build and test for convenience",
  )
  .option("-v, --version", "output the current version")
  .allowExcessArguments()
  .allowUnknownOption();
addTestOptions(program);
program.action(async (opts) => {
  await handleBuild();
  await handleTest(transformTestOptions(opts));
});
program.parse();
