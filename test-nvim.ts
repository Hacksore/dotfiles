#!/usr/bin/env node

import { execSync, spawn } from "child_process";
import { existsSync, mkdirSync, symlinkSync, renameSync } from "fs";

// Constants
const DOTFILES_REPO = "https://github.com/Hacksore/dotfiles.git";
const APP_DIR = "/app";
const CONFIG_DIR = `${process.env.HOME}/.config`;
const NVIM_CONFIG = `${CONFIG_DIR}/nvim`;
const LAZY_LOCK_ORIGINAL = `${NVIM_CONFIG}/lazy-lock.original.json`;
const LAZY_LOCK_GENERATED = `${NVIM_CONFIG}/lazy-lock.json`;

function execCommand(command: string, args: string[] = [], options: any = {}): string {
  try {
    return execSync(`${command} ${args.join(" ")}`, {
      encoding: "utf8",
      stdio: "pipe",
      ...options
    });
  } catch (error: any) {
    if (error.status !== 0) {
      throw error;
    }
    return error.stdout || "";
  }
}

function spawnCommand(command: string, args: string[] = [], options: any = {}): Promise<void> {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: "inherit",
      ...options
    });

    child.on("close", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Command failed with exit code ${code}`));
      }
    });

    child.on("error", reject);
  });
}

async function main() {
  try {
    // Get nvim version from first argument
    const nvimVersion = process.argv[2] || "stable";

    console.log(execCommand("which nvim"));

    // Setup dotfiles
    mkdirSync(CONFIG_DIR, { recursive: true });

    // Determine dotfiles path based on LOCAL env var
    let dotfilesPath: string;
    if (process.env.LOCAL === "1") {
      console.log("🏠 Testing using local dotfiles");
      dotfilesPath = `${APP_DIR}/localdotfiles/.config`;
    } else {
      execCommand("git", ["clone", DOTFILES_REPO, `${APP_DIR}/dotfiles`]);
      dotfilesPath = `${APP_DIR}/dotfiles/.config`;
    }

    // link the dotfiles nvim config
    try {
      symlinkSync(`${dotfilesPath}/nvim`, NVIM_CONFIG);
    } catch (error) {
      // symlink might already exist, continue
    }

    if (process.env.FROZEN_LOCKFILE === "1") {
      console.log("FROZEN_LOCKFILE (ON): using existing lockfile without modification");
    } else {
      console.log("FROZEN_LOCKFILE (OFF): backing up original lazy-lock.json for comparison");
      if (existsSync(LAZY_LOCK_GENERATED)) {
        renameSync(LAZY_LOCK_GENERATED, LAZY_LOCK_ORIGINAL);
      }
    }

    if (process.env.SKIP_CARGO !== "0") {
      // install rust and cargo
      execCommand("bash", ["-c", "curl --proto \"=https\" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly"]);

      // source cargo env
      process.env.PATH = `${process.env.HOME}/.cargo/bin:${process.env.PATH}`;

      // add cargo to PATH in bashrc
      execCommand("bash", ["-c", `echo "export PATH="$HOME/.cargo/bin:$PATH"" >> "$HOME/.bashrc"`]);
    }

    // Run nvim with TypeScript LSP test using TestTypescriptLSP command
    // FIXME: this is a hack and we can"t use auto installed cause it wont work in headless mode
    // https://github.com/mason-org/mason-lspconfig.nvim/issues/456
    // NOTE: this will catch breaking lua changes for neovim and exit with non-zero code
    // and it should print out the error in the logs
    await spawnCommand("nvim", [
      "--headless",
      "-e",
      "-c", "MasonInstall typescript-language-server",
      "-c", 'exe !!v:errmsg."cquit"'
    ], {
      env: { ...process.env, CI: "1" }
    });

    console.log("Typescript LSP should be installed now, running validation test...");

    // Compare original and generated lazy-lock.json (only if not using frozen lockfile)
    if (process.env.FROZEN_LOCKFILE !== "1") {
      console.log("📝 Lazy lock diff.\n");
      try {
        const output = execCommand("diff", ["-u", "--color=always", LAZY_LOCK_ORIGINAL, LAZY_LOCK_GENERATED]);
        console.log(output);
      } catch (error: any) {
        // diff returns non-zero exit code when files differ, which is expected
        if (error.status !== 1) {
          throw error;
        }
        console.log(error.stdout || "");
      }
    }

    // run the lsp validation test
    await spawnCommand("nvim", [
      "--headless",
      "-e",
      "-c", "TestLSPTypescript",
      "-c", 'exe !!v:errmsg."cquit"',
      "/app/test/typescript/simple.ts"
    ], {
      env: { ...process.env, CI: "1" }
    });

    console.log("💻 Nvim version");
    const output = execCommand("nvim", ["-V1", "-v"]);
    console.log(output);

  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

main();
