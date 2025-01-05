import { spawn } from "node:child_process";
import { program } from "commander";

program.option("-c, --channel [channel]", "channel to install", "stable");
program.parse();

const options = program.opts();

async function runCommand(command: string) {
  const child = spawn(command, { shell: true, stdio: "inherit" });

  await new Promise((resolve) => {
    child.on("close", (code) => {
      resolve(code);
    });
  });
}

await runCommand(
  "docker build --platform linux/amd64 --progress=plain . -t hacksore/nvim",
);

await runCommand(
  `docker run --platform linux/amd64 -e LOCAL=1 --rm hacksore/nvim ${options.channel}`,
);
