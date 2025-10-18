import { spawn } from "node:child_process";

export async function runCommand(command: string) {
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

export async function runCommandWithOutput(
  command: string,
): Promise<{ success: boolean; output: string; error: string }> {
  return new Promise((resolve) => {
    const child = spawn(command, { shell: true });

    let stdout = "";
    let stderr = "";

    child.stdout?.on("data", (data) => {
      stdout += data.toString();
    });

    child.stderr?.on("data", (data) => {
      stderr += data.toString();
    });

    child.on("close", (code) => {
      resolve({
        success: code === 0,
        output: stdout,
        error: stderr,
      });
    });

    child.on("error", (error) => {
      resolve({
        success: false,
        output: stdout,
        error: stderr + error.message,
      });
    });
  });
}

/**
 * Parse various boolean representations from environment variables or CLI args
 * Supports: "true", "false", "1", "0", "yes", "no", "on", "off"
 * Case insensitive
 */
export const parseFlagToBoolean = (
  value: string | boolean | undefined,
): boolean => {
  if (typeof value === "boolean") return value;
  if (typeof value === "undefined") return false;

  const normalized = String(value).toLowerCase().trim();

  // Truthy values
  if (["true", "1", "yes", "on"].includes(normalized)) {
    return true;
  }

  // Falsy values
  if (["false", "0", "no", "off", ""].includes(normalized)) {
    return false;
  }

  // Default to false for unrecognized values
  return false;
};
