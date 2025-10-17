import { runCommand } from "../utils.ts";
import fs from "node:fs";

export async function handleRun() {
  // if not i docker exit saying this command should be running in the container
  if (!fs.existsSync('/.dockerenv')) {
    return console.error("The 'hack run' command should be executed inside the Docker container.");
  }
  
  await runCommand("nvim-stable --version")
  await runCommand("nvim-nightly --version")
}
