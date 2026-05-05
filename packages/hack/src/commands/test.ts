import fs from "node:fs";
import os from "node:os";
import { mkdirp } from "fs-extra/esm";
import {
  type ContainerRuntime,
  getContainerRunCommand,
  resolveContainerRuntime,
} from "../constants.ts";
import { CommandError, runCommand } from "../utils.ts";

type TestOptions = {
  nightly: boolean;
  frozenLock: boolean;
  remote: boolean;
  skipCargo: boolean;
  runtime?: ContainerRuntime;
};

function getContainerTestArgs(options: TestOptions): string[] {
  const args: string[] = [];

  if (options.nightly) args.push("--nightly");
  if (options.frozenLock) args.push("--frozen-lock");
  if (options.remote) args.push("--remote");
  if (options.skipCargo) args.push("--skip-cargo");

  return args;
}

const isInsideContainer = (): boolean => {
  return (
    process.env.HACK_CONTAINER === "1" ||
    fs.existsSync("/.dockerenv") ||
    fs.existsSync("/.finchenv") ||
    fs.existsSync("/.applecontainerenv")
  );
};

/**
 * Spawns a container to run tests if not already inside one.
 * @returns {Promise<boolean>} Returns true if a container was spawned, false otherwise.
 */
const spawnContainer = async (options: TestOptions): Promise<boolean> => {
  const isContainer = isInsideContainer();
  const isCodespace = Boolean(process.env.CODESPACES);
  if (isContainer && !isCodespace) {
    return false;
  }

  const runtime = resolveContainerRuntime(options.runtime);
  const command = getContainerRunCommand(
    runtime,
    getContainerTestArgs(options),
  );

  // spawn container
  try {
    await runCommand(command);
  } catch (error) {
    if (error instanceof CommandError) {
      console.error("\nTest failed while running:");
      console.error(error.command);
      console.error(`Container runtime exited with code ${error.exitCode}`);
    } else {
      console.error("Test failed:", error);
    }
    process.exit(1);
  }

  return true;
};

export async function handleTest(options: TestOptions) {
  const spawnedContainer = await spawnContainer(options);
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
