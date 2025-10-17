#!/usr/bin/env node
import { program } from "commander";
import packageJson from "../package.json"  with { type: "json" };
import { handleBuild } from "./commands/build.ts";
import { handleTest } from "./commands/test.ts";
import { handleRun } from "./commands/run.ts";

program
  .command("build")
  .description("build the docker image")
  .option("-n, --nightly", "use nightly for bleeding edge neovim")
  .allowUnknownOption()
  .action(handleBuild);

program
  .command("test")
  .description("test the nvim config in the docker image")
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
  .allowUnknownOption()
  .action(handleTest);

program
  .command("run")
  .description("Run the neovim tests")
  .allowUnknownOption()
  .action(handleRun);

program
  .name("hack")
  .description("CLI to manage various things for building my neovim config")
  .option("-v, --version", "output the current version")
  .allowUnknownOption()
  .action((options) => {
    if (options.version) {
      console.log(`Hack CLI version ${packageJson.version}`);
      process.exit(0);
    }
    program.outputHelp();
  })
  .parse();
