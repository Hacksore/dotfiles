import fs from "node:fs";
import os from "node:os";
import { argv } from "node:process";
import { mkdirp } from "fs-extra/esm";
import { IMAGE_NAME } from "../constants.ts";
import { runCommand } from "../utils.ts";

/**
 * Spawns a Docker container to run tests if not already inside one.
 * @returns {Promise<boolean>} Returns true if a container was spawned, false otherwise.
 */
const spawnContainer = async (): Promise<boolean> => {
  const isInsideDocker = fs.existsSync("/.dockerenv");
  if (isInsideDocker) {
    return false;
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
};

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
  const nvimBin = options.nightly ? "nvim-nightly" : "nvim-stable";

  // print a nice table of all the options enabled
  console.log("🧪 Running tests with the following options:");
  console.table({
    "Neovim Nightly": options.nightly,
    "Frozen Lockfile": frozenLock,
    "Remote Dotfiles": remote,
    "Skip Cargo Install": skipCargo,
  });

  if (!skipCargo) {
    console.log("🚚 Installing cargo...");
    await runCommand(
      `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly`,
    );

    process.env.PATH = `${os.homedir()}/.cargo/bin:${process.env.PATH}`;
  }

  const homeDir = os.homedir();
  mkdirp(`${homeDir}/.config`);

  if (remote) {
    await runCommand(
      `git clone https://github.com/Hacksore/dotfiles.git /app/remote-dotfiles`,
    );

    await runCommand(
      `ln -s /app/remote-dotfiles/.config/nvim $HOME/.config/nvim`,
    );
  } else {
    await runCommand(
      `ln -s /app/localdotfiles/.config/nvim $HOME/.config/nvim`,
    );
  }

  // copy the old lack file to a new copy
  fs.copyFileSync(
    `${homeDir}/.config/nvim/lazy-lock.json`,
    `${homeDir}/.config/nvim/lazy-lock.original.json`,
  );

  try {
    // Run nvim with TypeScript LSP test using TestTypescriptLSP command
    // FIXME: this is a hack and we can't use auto installed cause it wont work in headless mode
    // https://github.com/mason-org/mason-lspconfig.nvim/issues/456
    // NOTE: this will catch breaking lua changes for neovim and exit with non-zero code
    // and it should print out the error in the logs
    await runCommand(
      `${nvimBin} --headless -e -c "MasonInstall typescript-language-server" -c 'exe !!v:errmsg."cquit"'`,
    );

    console.log("\n\n");

    // NOTE: run the test case for typescript LSP
    await runCommand(
      `${nvimBin} --headless -e -c "TestLSPTypescript" -c 'exe !!v:errmsg."cquit"' "/app/test/typescript/simple.ts"`,
    );

    if (!frozenLock) {
      console.log("📝 Preparing lazy diff to see what changed...");

      // NOTE: do the dif for the lock file
      await runCommand(
        `diff -u --color=always ${homeDir}/.config/nvim/lazy-lock.original.json ${homeDir}/.config/nvim/lazy-lock.json && echo $? || true`,
      );
    }

    console.log("✅ Noevim test run succesfully...");
    await runCommand(`${nvimBin} -V1 -v`);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}
