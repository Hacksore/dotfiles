import { runCommand } from "../utils.ts";

export async function handleRun() {
  
  await runCommand("nvim-stable --version")
  await runCommand("nvim-nightly --version")
}
