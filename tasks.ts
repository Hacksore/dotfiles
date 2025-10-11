import { spawn } from "node:child_process";
import { program } from "commander";

const IMAGE_NAME = "hacksore/nvim";

program
  .command("build")
  .description("build the docker image")
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
  .action(handleTest);

program.parse();

async function runCommand(command: string) {
  const child = spawn(command, { shell: true, stdio: "inherit" });

  await new Promise((resolve, reject) => {
    child.on("close", (code) => {
      if (code === 0) {
        resolve(code);
      } else {
        reject(new Error(`Command failed with exit code ${code}`));
      }
    });
    
    child.on("error", (error) => {
      reject(error);
    });
  });
}

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

  console.log({ frozenLock, channel, options });

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
