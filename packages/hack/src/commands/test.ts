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
      `docker run -e CI=1 --rm ${IMAGE_NAME} ${argv.slice(3).join(" ")}`,
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

  // we need to link the local dotfiles
  await runCommand(
    `ln -s /app/localdotfiles/.config/nvim $HOME/.config/nvim`,
  );

  await runCommand("ls -hal $HOME/.config/nvim");
  await runCommand("ls -hal $HOME/.config/nvim");
  await runCommand("ls -hal $HOME/.config/nvim/init.lua");
  await runCommand("echo $HOME");

  console.log({ options, argv, hostname: os.hostname() })

  try {
    // Run nvim with TypeScript LSP test using TestTypescriptLSP command
    // FIXME: this is a hack and we can't use auto installed cause it wont work in headless mode
    // https://github.com/mason-org/mason-lspconfig.nvim/issues/456
    // NOTE: this will catch breaking lua changes for neovim and exit with non-zero code
    // and it should print out the error in the logs
    await runCommand(
      `nvim-stable --headless -e -c "MasonInstall typescript-language-server" -c 'exe !!v:errmsg."cquit"'`,
    );

  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}
