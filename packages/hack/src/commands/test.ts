import { IMAGE_NAME } from "../constants.ts";
import { parseFlagToBoolean, runCommand } from "../utils.ts";
import fs from "node:fs";
import os from "node:os";
import { argv } from "node:process";

export async function handleTest(options: {
  nightly: boolean;
  frozenLock: boolean;
  remote: boolean;
  skipCargo: boolean;
}) {
  const isInsideDocker = fs.existsSync('/.dockerenv');
  const { frozenLock, remote, skipCargo } = options;
  const frozenLockfile = parseFlagToBoolean(frozenLock) ? "1" : "0";
  const useCargo = parseFlagToBoolean(skipCargo) ? "1" : "0";
  const useLocal = remote ? "0" : "1";

  console.log({ options, argv, isInsideDocker, hostname: os.hostname() })

  // spawn docker container
  if (!isInsideDocker) {
    try {
      await runCommand(
        `docker run --rm ${IMAGE_NAME} ${argv.slice(3).join(" ")}`,
      );
    } catch (error) {
      console.error("Test failed:", error.message);
      process.exit(1);
    }
  }

  // logic that runs inside the docker container to test neovim
  console.log("running in the docker container")


  try {
    await runCommand("/usr/local/bin/nvim-stable --version")
  } catch (error) {
  }
}
