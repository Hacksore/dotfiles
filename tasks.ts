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
  .option("-c, --channel [channel]", "channel to install", "stable")
  .option(
    "-f, --frozen-lock",
    "if it should use the existing commit lock file",
    false,
  )
  .action(handleTest);

program.parse();

async function runCommand(command: string) {
  const child = spawn(command, { shell: true, stdio: "inherit" });

  await new Promise((resolve) => {
    child.on("close", (code) => {
      resolve(code);
    });
  });
}

async function handleBuild() {
  await runCommand(`docker build --platform linux/amd64 . -t ${IMAGE_NAME}`);
}

async function handleTest({
  channel,
  frozenLock,
}: { channel: string; frozenLock: boolean }) {
  const frozenLockfile = frozenLock ? "1" : "0";

  console.log(`Running test with channel: ${channel} and frozenLock: ${frozenLockfile}`);

  await runCommand(
    `docker run --platform linux/amd64 -e LOCAL=1 -e FRONZENED_LOCKFILE=${frozenLockfile} --rm ${IMAGE_NAME} ${channel}`,
  );
}
