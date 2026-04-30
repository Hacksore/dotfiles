import ora from "ora";
import picocolors from "picocolors";
import { IMAGE_NAME } from "../constants.ts";
import { runCommandWithOutput } from "../utils.ts";

function formatElapsed(ms: number): string {
  const s = Math.floor(ms / 1000);
  if (s < 60) return `${s}s`;
  const m = Math.floor(s / 60);
  const rem = s % 60;
  return rem ? `${m}m ${rem}s` : `${m}m`;
}

export async function handleBuild() {
  const start = Date.now();
  const spinner = ora(`Building Docker image (${formatElapsed(0)})`).start();

  const interval = setInterval(() => {
    spinner.text = `Building Docker image (${formatElapsed(Date.now() - start)})`;
  }, 1000);

  try {
    const result = await runCommandWithOutput(
      `docker build --platform linux/amd64 . -t ${IMAGE_NAME}`,
    );

    clearInterval(interval);
    const duration = formatElapsed(Date.now() - start);

    if (result.success) {
      spinner.stopAndPersist({
        symbol: "✅",
        text: picocolors.green(`BUILD SUCCEEDED (${duration})`),
      });
    } else {
      spinner.stopAndPersist({
        symbol: "🛑",
        text: picocolors.red(`BUILD FAILED (${duration})`),
      });
      console.error("\nBuild output:");
      console.error(result.output);
      console.error("\nError output:");
      console.error(result.error);
      process.exit(1);
    }
  } catch (error) {
    clearInterval(interval);
    const duration = formatElapsed(Date.now() - start);
    spinner.fail(`Build failed (${duration})`);
    console.error("Build failed:", error.message);
    process.exit(1);
  }
}
