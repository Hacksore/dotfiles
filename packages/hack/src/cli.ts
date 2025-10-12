#!/usr/bin/env -S pnpx tsx
import { program } from "commander";
import { version as npmVersion } from "../package.json";
import { parseFlagToBoolean, runCommand, runCommandWithOutput } from "./utils.js";
import ora from "ora";

const IMAGE_NAME = "hacksore/nvim";

program
  .command("build")
  .description("build the docker image")
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
  .option("-n, --nightly", "use nightly for bleeding edge neovim")
  .allowUnknownOption()
  .action(handleTest);

program
  .name("hack")
  .description("CLI to manage various things for building my neovim config")
  .option("-v, --version", "output the current version")
  .allowUnknownOption()
  .action((options) => {
    if (options.version) {
      console.log(`Hack CLI version ${npmVersion}`);
      process.exit(0);
    }
    program.outputHelp();
  })
  .parse();

async function handleBuild() {
  const spinner = ora("🏗️ Starting hack build").start();

  try {
    const result = await runCommandWithOutput(`docker build --platform linux/amd64 . -t ${IMAGE_NAME}`);

    if (result.success) {
      spinner.stopAndPersist({ symbol: "✅", text: "Build succeeded" });
    } else {
      spinner.fail("Build failed");
      console.error("\nBuild output:");
      console.error(result.output);
      console.error("\nError output:");
      console.error(result.error);
      process.exit(1);
    }
  } catch (error) {
    spinner.fail("Build failed");
    console.error("Build failed:", error.message);
    process.exit(1);
  }
}

async function handleTest(options: {
  nightly: boolean;
  frozenLock: boolean;
  remote: boolean;
  skipCargo: boolean;
}) {
  const { nightly, frozenLock, remote, skipCargo } = options;
  const frozenLockfile = parseFlagToBoolean(frozenLock) ? "1" : "0";
  const useLocal = remote ? "0" : "1";
  const useCargo = parseFlagToBoolean(skipCargo) ? "1" : "0";
  const selectedChannel = nightly ? "nightly" : "stable";

  console.log(options)

  try {

    // TODO: i hate that we nave to use env vars to pass args to docker
    // we could pass to stdin but that would be more complex to handle
    const envVars = {
      SKIP_CARGO: useCargo,
      LOCAL: useLocal,
      FROZEN_LOCKFILE: frozenLockfile,
    };

    const envString = Object.entries(envVars)
      .map(([key, value]) => `-e ${key}=${value}`)
      .join(" ");

    await runCommand(
      `docker run ${envString} --rm ${IMAGE_NAME} ${selectedChannel}`,
    );
  } catch (error) {
    console.error("Test failed:", error.message);
    process.exit(1);
  }
}
