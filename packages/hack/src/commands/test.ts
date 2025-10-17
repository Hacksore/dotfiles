import { IMAGE_NAME } from "../constants.ts";
import { parseFlagToBoolean, runCommand } from "../utils.ts";
import fs from "node:fs";
import os from "node:os";
import { argv } from "node:process";

/**
 * Spawns a Docker container to run tests if not already inside one.
 * @returns {Promise<boolean>} - Returns true if a container was spawned, false otherwise.
 */
const spawnContainer = async () => {
  const isInsideDocker = fs.existsSync('/.dockerenv');
  console.log({ isInsideDocker });
  if (isInsideDocker) {
    return false
  }

  // spawn docker container
  try {
    await runCommand(
      `docker run --rm ${IMAGE_NAME} ${argv.slice(3).join(" ")}`,
    );
  } catch (error) {
    console.error("Test failed:", error.message);
    process.exit(1);
  }

  return true;
}

export async function handleTest(options: {
  nightly: boolean;
  frozenLock: boolean;
  remote: boolean;
  skipCargo: boolean;
}) {
  const spawnedContainer = await spawnContainer();
  if (spawnedContainer) {
    return;
  }

  const { frozenLock, remote, skipCargo } = options;
  const frozenLockfile = parseFlagToBoolean(frozenLock) ? "1" : "0";
  const useCargo = parseFlagToBoolean(skipCargo) ? "1" : "0";
  const useLocal = remote ? "0" : "1";

  console.log({ options, argv, hostname: os.hostname() })

  try {
    await runCommand("/usr/local/bin/nvim-stable --version")
    console.log("✅ nvim-stable version check passed")
  } catch (error) {
    console.error("❌ nvim-stable version check failed:", error.message)
  }
}
