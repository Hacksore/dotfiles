#!/usr/bin/env -S pnpx tsx
import { program } from "commander";
import { version as npmVersion } from "../package.json";
import { runCommand } from "./utils.js";

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
    "--frozen-lock",
    "if it should use the existing commit lazy lock file",
    false,
  )
  .option("-c, --channel [channel]", "channel to install", "stable")
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
  try {
    await runCommand(`docker build --platform linux/amd64 . -t ${IMAGE_NAME}`);
    console.log("Build completed successfully");
  } catch (error) {
    console.error("Build failed:", error.message);
    process.exit(1);
  }
}

async function handleTest(options: { channel: string; frozenLock: boolean }) {
  const { channel, frozenLock } = options;
  const frozenLockfile = frozenLock ? "1" : "0";

  try {
    await runCommand(
      `docker run -e LOCAL=1 -e FROZEN_LOCKFILE="${frozenLockfile}" --rm ${IMAGE_NAME} ${channel}`,
    );
    console.log("Test completed successfully");
  } catch (error) {
    console.error("Test failed:", error.message);
    process.exit(1);
  }
}
