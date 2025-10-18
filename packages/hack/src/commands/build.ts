import ora from "ora";
import picocolors from "picocolors";
import { IMAGE_NAME } from "../constants.ts";
import { runCommandWithOutput } from "../utils.ts";

export async function handleBuild() {
  const spinner = ora("Starting hack build").start();

  try {
    const result = await runCommandWithOutput(
      `docker build --platform linux/amd64 . -t ${IMAGE_NAME}`,
    );

    if (result.success) {
      spinner.stopAndPersist({
        symbol: "✅",
        text: picocolors.green("BUILD SUCCEEDED"),
      });
    } else {
      spinner.stopAndPersist({
        symbol: "🛑",
        text: picocolors.red("BUILD FAILED"),
      });
      console.error("\nBuild output:");
      console.error(result.output);
      console.error("\nError output:");
      console.error(result.error);
      process.exit(1);
    }
  } catch (error) {
    spinner.fail("Build failed");
    console.error("Build failed:", error.message);
    process.exit(1);
  }
}
