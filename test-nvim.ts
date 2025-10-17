#!/usr/bin/env node

import { execa } from "execa";
import { existsSync, mkdirSync, symlinkSync, renameSync } from "fs";

// Constants
const DOTFILES_REPO = "https://github.com/Hacksore/dotfiles.git";
const APP_DIR = "/app";
const NVIM_DIR = `${APP_DIR}/nvim`;
const NVIM_BIN_DIR = `${NVIM_DIR}/nvim-linux-x86_64/bin`;
const NVIM_TAR = `${NVIM_DIR}/nvim.tar.gz`;
const CONFIG_DIR = `${process.env.HOME}/.config`;
const NVIM_CONFIG = `${CONFIG_DIR}/nvim`;
const LAZY_LOCK_ORIGINAL = `${NVIM_CONFIG}/lazy-lock.original.json`;
const LAZY_LOCK_GENERATED = `${NVIM_CONFIG}/lazy-lock.json`;

// URLs for different nvim versions
const NIGHTLY_URL =
  "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz";
const STABLE_URL =
  "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz";

async function main() {
  try {
    // Get nvim version from first argument
    const nvimVersion = process.argv[2] || "stable";

    // Setup dotfiles
    mkdirSync(CONFIG_DIR, { recursive: true });

    // Determine dotfiles path based on LOCAL env var
    let dotfilesPath: string;
    if (process.env.LOCAL === "1") {
      console.log("🏠 Testing using local dotfiles");
      dotfilesPath = `${APP_DIR}/localdotfiles/.config`;
    } else {
      await execa("git", ["clone", DOTFILES_REPO, `${APP_DIR}/dotfiles`]);
      dotfilesPath = `${APP_DIR}/dotfiles/.config`;
    }

    // link the dotfiles nvim config
    try {
      symlinkSync(`${dotfilesPath}/nvim`, NVIM_CONFIG);
    } catch (error) {
      // symlink might already exist, continue
    }

    // Download and install nvim
    mkdirSync(NVIM_DIR, { recursive: true });

    let downloadUrl: string;
    switch (nvimVersion) {
      case "nightly":
        downloadUrl = NIGHTLY_URL;
        break;
      case "stable":
        downloadUrl = STABLE_URL;
        break;
      default:
        console.error(
          `Invalid nvim version: ${nvimVersion}. Use 'stable' or 'nightly'`
        );
        process.exit(1);
    }

    // Download nvim
    await execa("wget", ["-q", downloadUrl, "-O", NVIM_TAR]);

    // Extract and link nvim binary
    await execa("tar", ["xzf", NVIM_TAR, "-C", NVIM_DIR]);
    try {
      symlinkSync(`${NVIM_BIN_DIR}/nvim`, "/usr/bin");
    } catch (error) {
      // symlink might already exist, continue
    }

    if (process.env.FROZEN_LOCKFILE === "1") {
      console.log(
        "FROZEN_LOCKFILE (ON): using existing lockfile without modification"
      );
    } else {
      console.log(
        "FROZEN_LOCKFILE (OFF): backing up original lazy-lock.json for comparison"
      );
      if (existsSync(LAZY_LOCK_GENERATED)) {
        renameSync(LAZY_LOCK_GENERATED, LAZY_LOCK_ORIGINAL);
      }
    }

    if (process.env.SKIP_CARGO !== "0") {
      // install rust and cargo
      await execa(
        "curl",
        ["--proto", "=https", "--tlsv1.2", "-sSf", "https://sh.rustup.rs"],
        {
          input: "y\n",
          stdio: ["pipe", "pipe", "pipe"],
        }
      );

      // source cargo env
      process.env.PATH = `${process.env.HOME}/.cargo/bin:${process.env.PATH}`;

      // add cargo to PATH in bashrc
      await execa("bash", [
        "-c",
        `echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"`,
      ]);
    }

    // Run nvim with TypeScript LSP test using TestTypescriptLSP command
    // FIXME: this is a hack and we can't use auto installed cause it wont work in headless mode
    // https://github.com/mason-org/mason-lspconfig.nvim/issues/456
    // NOTE: this will catch breaking lua changes for neovim and exit with non-zero code
    // and it should print out the error in the logs
    await execa(
      "nvim",
      [
        "--headless",
        "-e",
        "-c",
        "MasonInstall typescript-language-server",
        "-c",
        'exe !!v:errmsg."cquit"',
      ],
      {
        env: { ...process.env, CI: "1" },
      }
    );

    console.log(
      "Typescript LSP should be installed now, running validation test..."
    );

    // Compare original and generated lazy-lock.json (only if not using frozen lockfile)
    if (process.env.FROZEN_LOCKFILE !== "1") {
      console.log("📝 Lazy lock diff.\n");
      try {
        const { stdout } = await execa("diff", [
          "-u",
          "--color=always",
          LAZY_LOCK_ORIGINAL,
          LAZY_LOCK_GENERATED,
        ]);
        console.log(stdout);
      } catch (error) {
        // diff returns non-zero exit code when files differ, which is expected
        if (error.exitCode !== 1) {
          throw error;
        }
      }
    }

    // run the lsp validation test
    await execa(
      "nvim",
      [
        "--headless",
        "-e",
        "-c",
        "TestLSPTypescript",
        "-c",
        'exe !!v:errmsg."cquit"',
        "/app/test/typescript/simple.ts",
      ],
      {
        env: { ...process.env, CI: "1" },
      }
    );

    console.log("💻 Nvim version");
    const { stdout } = await execa("nvim", ["-V1", "-v"]);
    console.log(stdout);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

main();
