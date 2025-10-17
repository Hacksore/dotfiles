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
  const { frozenLock, remote, skipCargo } = options;
  const frozenLockfile = parseFlagToBoolean(frozenLock) ? "1" : "0";
  const useLocal = remote ? "0" : "1";
  const useCargo = parseFlagToBoolean(skipCargo) ? "1" : "0";

  console.log({ options, argv, docker: fs.existsSync('/.dockerenv'), hostname: os.hostname() })

  // only spawn this once on the host machine
  if (!fs.existsSync('/.dockerenv')) {
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
    await runCommand("nvim-nightly --version")
  } catch (error) {
  }
}
