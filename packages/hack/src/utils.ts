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

/**
 * Parse various boolean representations from environment variables or CLI args
 * Supports: "true", "false", "1", "0", "yes", "no", "on", "off"
 * Case insensitive
 */
export const parseBooleanEnvVar = (value: string | boolean | undefined): boolean => {
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
}